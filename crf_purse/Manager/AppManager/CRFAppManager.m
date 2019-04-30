//
//  CRFAppManager.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFAppManager.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "CRFSettingData.h"
#import "CRFTimeUtil.h"
#import "CRFBasicView.h"
#import "CRFFilePath.h"
#import "CRFHomeAdvertisementView.h"
#import "CRFAuthView.h"
#import "CRFGestureManager.h"

@interface CRFAppManager()
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) LAContext *context;

@property (nonatomic, strong) UIVisualEffectView *effectview;

@end

@implementation CRFAppManager

@synthesize nowTime = _nowTime;

- (BOOL)accountStatus {
    return [self.userInfo.accountStatus integerValue] == 2;
}

- (LAContext *)context {
    if (!_context) {
        _context = [[LAContext alloc] init];
        if ([_context respondsToSelector:@selector(setMaxBiometryFailures:)]) {
            _context.maxBiometryFailures = @(3);
        }
        if ([_context respondsToSelector:@selector(setLocalizedCancelTitle:)]) {
            _context.localizedCancelTitle = NSLocalizedString(@"touchID_button_cancel", nil);
        }
        _context.localizedFallbackTitle = @"";
    }
    return _context;
}

//- (BOOL)majiabaoFlag {
//    return NO;
//}

+ (instancetype)defaultManager {
    static CRFAppManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSString *)unMessageCount{
    if (!_unMessageCount||_unMessageCount.integerValue < 1) {
        _unMessageCount = @"0";
    }
    return _unMessageCount;
}

- (instancetype)init {
    if (self = [super init]) {
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(applicationDidOver) name:UIApplicationWillTerminateNotification];
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(applicationDidEndBackground) name:UIApplicationDidEnterBackgroundNotification];
        [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification];
    }
    return self;
}

- (void)applicationDidEndBackground {
    [CRFUserDefaultManager setAppBackgroundTime];
}

- (void)applicationBecomeActive {
    [CRFGestureManager hotStartVerifyGesture];
}

- (void)applicationDidOver {
    if (!self.login) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}
//UIApplicationUserDidTakeScreenshotNotification

- (BOOL)login {
    return self.userInfo.userId.length > 0;
}

- (long long)nowTime {
    if (_nowTime <= 0) {
        _nowTime = [CRFTimeUtil getCurrentTimeInteveral];
    }
    return _nowTime;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDowm:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (void)setNowTime:(long long)nowTime {
    _nowTime = nowTime;
    //    if (_nowTime > [CRFTimeUtil getCurrentTimeInteveral]) {
    [self.timer fire];
    //    }
}

- (void)countDowm:(NSTimer *)time {
    _nowTime = (_nowTime / 1000 + 1) * 1000;
    //    if (self.nowTime <= [CRFTimeUtil getCurrentTimeInteveral]) {
    //        [self stopTime];
    //    }
}

- (void)stopTime {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (BOOL)supportTouchID {
    NSError *error = nil;
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    BOOL result = [self.context canEvaluatePolicy:policy error:&error];
//    if ([self supportFaceID]) {
//        return NO;
//    }
    if (!result || error) {
        return NO;
    }
    return result;
}

- (BOOL)supportFaceID {
    if (@available(iOS 11.0, *)) {
        if (self.context.biometryType == LABiometryTypeFaceID){
            return YES;
        }
    }
    return NO;
}

- (void)verifyInvestTouchID:(void (^)(TouchStatus))resultCallback{
    NSError *error;
    if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"invest_touchID_message", nil) reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                DLog(@"touchID 验证成功");
                if (resultCallback) {
                    resultCallback(VerifySuccess);
                }
            }
        }];
    }
}

- (void)verifyTouchID:(void (^)(TouchStatus))resultCallback {
    NSString *destring = NSLocalizedString(@"touchID_message", nil);
    if (@available(iOS 11.0, *)) {
        if (self.context.biometryType == LABiometryTypeFaceID){
            destring = @"请验证Face ID，确认登录";
        }
        if (self.context.biometryType == LABiometryNone) {
            destring = @"unknow";
        }
    }
    NSError *error;
    if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:destring reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                DLog(@"验证成功");
                if (resultCallback) {
                    resultCallback(VerifySuccess);
                }
            } else {
                NSInteger code = error.code;
                switch (code) {
                    case kLAErrorAuthenticationFailed: {
                        DLog(@"指纹验证失败");
                        if (resultCallback) {
                            resultCallback(VerifyFailed);
                        }
                    }
                        break;
                    case kLAErrorUserCancel: {
                        DLog(@"用户点击取消");
                        if (resultCallback) {
                            resultCallback(UserCancel);
                        }
                    }
                        break;
                    case kLAErrorUserFallback: {
                        DLog(@"认证被取消,用户点击回退按钮(输入密码)");
                        if (resultCallback) {
                            resultCallback(InputPassword);
                        }
                    }
                        break;
                    case kLAErrorSystemCancel: {
                        DLog(@"身份验证被系统取消,(比如另一个应用程序去前台,切换到其他 APP)");
                        if (resultCallback) {
                            resultCallback(SystemCancel);
                        }
                    }
                        break;
                        
                    case kLAErrorTouchIDLockout: {
                        DLog(@"多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁");
                        if (resultCallback) {
                            resultCallback(ForceLogout);
                        }
                    }
                        break;
                    case kLAErrorAppCancel: {
                        DLog(@"用户不能控制的挂起，例如突然来了电话，电话应用进入前台，APP被挂起。");
                        if (resultCallback) {
                            resultCallback(SystemCancel);
                        }
                    }
                        break;
                    case kLAErrorInvalidContext: {
                        DLog(@"授权过程中,LAContext对象被释放掉");
                        if (resultCallback) {
                            resultCallback(SystemCancel);
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
             self.context = nil;
        }];
    } else {
        if(error.code == LAErrorTouchIDNotEnrolled) {
            DLog(@"身份验证无法启动,因为没有登记的手指触摸ID。 没有设置指纹密码时。");
        }else if(error.code == LAErrorTouchIDNotAvailable) {
            DLog(@"身份验证无法启动,因为触摸ID在设备上不可用。");
            
        }else if(error.code == LAErrorPasscodeNotSet){
            DLog(@"身份验证无法启动,因为密码在设备上没有设置");
        }
        if (resultCallback) {
            resultCallback(NotFoundTouchID);
        }
         self.context = nil;
    }
}

- (BOOL)isOpenRemoteNotificationStatus{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return setting.types != UIUserNotificationTypeNone;
}

- (CRFUserInfo *)userInfo {
    if (!_userInfo) {
        _userInfo = [CRFSettingData getCurrentAccountInfo];
    }
    return _userInfo;
}
-(CRFNewRechargeModel *)rechargeModel{
//    if (!_rechargeModel) {
//        _rechargeModel = [CRFSettingData getRechargeInfo];
//    }
    _rechargeModel = [CRFSettingData getRechargeInfo];
    return _rechargeModel;
}
- (CRFClientInfo *)clientInfo {
    if (!_clientInfo) {
        _clientInfo = [CRFSettingData getCRFClientInfo];
    }
    return _clientInfo;
}

- (CRFLocationInfo *)locationInfo {
    if (!_locationInfo) {
        _locationInfo = [CRFLocationInfo new];
    }
    return _locationInfo;
}

- (CRFAccountInfo *)accountInfo {
    if (!_accountInfo) {
        _accountInfo = [CRFAccountInfo new];
    }
    return _accountInfo;
}

- (CRFAddress *)address {
    return [self.addresses firstObject];
}

- (NSArray<CRFBankCardInfo *> *)bankCards {
    if(!_bankCards) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"checkbankcard" ofType:@"json"];
        
        NSData *data=[NSData dataWithContentsOfFile:jsonPath];
        if (!data) {
            return @[];
        }
        NSError *error;
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
        if (!jsonObject) {
            return @[];
        }
        _bankCards = [NSArray yy_modelArrayWithClass:[CRFBankCardInfo class] json:jsonObject];
    }
    return _bankCards;
}

- (BOOL)userInfoExpired {
    long desTime = 3 * 24 * 60 * 60 * 1000;
    if ([CRFTimeUtil getCurrentTimeInteveral] - [CRFUserDefaultManager getUserLoginTime] > desTime) {
        [CRFUserDefaultManager removeLoginTime];
        return YES;
    }
    return NO;
}

- (void)removeWindowSubViews {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[CRFBasicView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)removeWindowUsenessViews {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[CRFBasicView class]] && ![view isKindOfClass:[CRFHomeAdvertisementView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (NSString *)bankListPath {
    return [CRFFilePath getBankCardListPath:[NSString stringWithFormat:@"bank_list_%ld",[CRFUserDefaultManager getBankDatasVersion]]];
}

- (void)addRemoteBankInfoWithLocal:(CRFCardSupportInfo *)bankCardInfo {
    if (![bankCardInfo.bankCardNo getBankCardInfo]) {
        /*
         @property (nonatomic ,copy) NSString *businessSupport;
         @property (nonatomic, copy) NSString *bankCardNo;
         @property (nonatomic, copy) NSString *bankCardType;
         @property (nonatomic, copy) NSString *bankCode;
         @property (nonatomic, copy) NSString *bankName;
         @property (nonatomic, copy) NSString *failCode;
         @property (nonatomic, copy) NSString *failReason;
         @property (nonatomic, copy) NSString *result;
         */
        CRFBankCardInfo *info = [CRFBankCardInfo new];
        info.bankName = bankCardInfo.bankName;
        info.bankCode = bankCardInfo.bankCode;
        info.cardBin = [bankCardInfo.bankCardNo substringToIndex:6];
        NSMutableArray *list = [self.bankCards mutableCopy];
        [list addObject:info];
        self.bankCards = list.copy;
    }
}


@end
