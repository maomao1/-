
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"
#import "PCCircleView.h"
#import "PCLockLabel.h"
#import "GestureViewController.h"
#import "PCCircle.h"
#import "PCCircleInfoView.h"
#import "CRFVerifyLoginView.h"
#import "CRFGestureManager.h"
#import "CRFAlertUtils.h"
#import "CRFGestureManager.h"

@interface GestureVerifyViewController ()<CircleViewDelegate>

/**
 *  文字提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

@property (nonatomic, strong) PCCircleInfoView *infoView;

@property (nonatomic, strong) CRFVerifyLoginView *verifyView;

@property (nonatomic, assign) NSInteger errorCount;


@end

@implementation GestureVerifyViewController

- (CRFVerifyLoginView *)verifyView {
    if (!_verifyView) {
        _verifyView = [[CRFVerifyLoginView alloc] init];
        weakSelf(self);
        [_verifyView setConfirmEvent:^(NSString *password){
               strongSelf(weakSelf);
             [[UIApplication sharedApplication].delegate.window endEditing:YES];
            if ([password isEmpty]) {
                [strongSelf.verifyView showErrorMessage:@"密码不能为空"];
                return ;
            }
            [CRFLoadingView disableLoading];
            [CRFGestureManager verifyPassword:password handler:^(BOOL success, id response) {
                [CRFLoadingView dismiss];
                if (success) {
                    [strongSelf.verifyView dismiss];
                    [CRFUtils showMessage:@"验证成功"];
                    [CRFUtils delayAfert:1 handle:^{
                         [strongSelf closeCurrentPage];
                    }];
                } else {
                    [strongSelf.verifyView showErrorMessage:response[kMessageKey]];
                }
            }];
        }];
    }
    return _verifyView;
}

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (BOOL)fd_interactivePopDisabled {
    return YES;
}

- (void)initializeView {
    if (self.type == GestureVerifyTypeLogin || self.type == GestureVerifyTypeSettingNew) {
        UIView *line = [UIView new];
        line.backgroundColor = kCellLineSeparatorColor;
        [self.view addSubview:line];
        UILabel *modifyLabel = [UILabel new];
        [self.view addSubview:modifyLabel];
        modifyLabel.text = self.type == GestureVerifyTypeLogin ? @"暂不关闭" :@"暂不修改    ";
        UILabel *verifyLabel = [UILabel new];
        [self.view addSubview:verifyLabel];
        modifyLabel.userInteractionEnabled = verifyLabel.userInteractionEnabled = YES;
        modifyLabel.font = verifyLabel.font = [UIFont systemFontOfSize:14];
        modifyLabel.textColor = verifyLabel.textColor = kCellTitleTextColor;
        modifyLabel.textAlignment = NSTextAlignmentRight;
        verifyLabel.text = @"验证登录密码";
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(- 81.5 * kWidthRatio));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(1, 12));
        }];
        [modifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.bottom.equalTo(@(- 80 * kWidthRatio));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2 - 10, 14));
        }];
        [verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view);
            make.bottom.equalTo(@(-80 * kWidthRatio));
            make.width.mas_equalTo(kScreenWidth / 2 - 10);
            make.height.mas_equalTo(14);
        }];
        [modifyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noModify)]];
        [verifyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(verifyPassword)]];
    } else {
        UILabel *label = [UILabel new];
//        if (self.type == GestureVerifyTypeSettingNew) {
             label.text = @"验证登录密码";
//        } else {
//             label.text = @"暂不设置";
//        }
       
        label.textColor = kTextEnableColor;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(@(-80 * kWidthRatio));
            make.height.mas_equalTo(14);
        }];
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noModify)]];
        
    }
}

- (void)noModify {
    if (self.type == GestureVerifyTypeSettingNew || self.type == GestureVerifyTypeLogin) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.resultHandler) {
                self.resultHandler();
            }
        }];
    } else {
        [self.verifyView show];
    }
}

- (void)verifyPassword {
    [self.verifyView show];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:^{
        [CRFNotificationUtils postNotificationName:kGestureErrorToLoginNotificationName];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [CRFNotificationUtils addNotificationWithObserver:self selector:@selector(dismissSelf) name:kDismissGestureNotificationName];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, 42 * kWidthRatio, 42 * kWidthRatio);
    infoView.center = CGPointMake(kScreenWidth/2, 120 * kWidthRatio);
    self.infoView = infoView;
    [self.view addSubview:infoView];
    
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    [lockView setType:CircleViewTypeVerify];
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenWidth, 14);
    msgLabel.center = CGPointMake(kScreenWidth/2, 191);
    [msgLabel showNormalMsg:gestureTextOldGesture];
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    [self initializeView];
    self.errorCount = 5;
}

#pragma mark - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功");
            [CRFUtils delayAfert:.3 handle:^{
                 [self closeCurrentPage];
            }];
        } else {
            NSLog(@"密码错误！");
            if (self.type == GestureVerifyTypeSettingNew || self.type == GestureVerifyTypeLogin) {
                self.errorCount --;
                if (self.errorCount == 0) {
                    [self.msgLabel showWarnMsgAndShake:@"多次错误"];
                    [CRFUserDefaultManager saveFinalGesture:nil];
                    [CRFAlertUtils showAlertTitle:@"温馨提示" message:@"多次输入错误，需要重新登录" container:self cancelTitle:nil confirmTitle:@"我知道了" cancelHandler:nil confirmHandler:^{
                        [CRFUserDefaultManager setGestureErrorMaxFlag:YES];
                        [self dismissViewControllerAnimated:YES completion:^{
                            [CRFNotificationUtils postNotificationName:kDismissGestureNotificationName];
                            [CRFNotificationUtils postNotificationName:kGestureErrorToLoginNotificationName];
                        }];
                    }];
                    return;
                }
                [self.msgLabel showWarnMsgAndShake:[NSString stringWithFormat:@"密码错误，您还可以输入%ld次",self.errorCount]];
            } else {
                [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
            }
        }
    }
}
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [CRFUserDefaultManager getTemporaryGesture];
    
    // 看是否存在第一个密码
    if ([gestureOne length]) {
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showRepeatMsg:gestureTextDrawAgain];
    
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    NSLog(@"获得第二个手势密码%@",gesture);
    
    if (equal) {
        
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        
        [CRFUtils showMessage:@"手势密码设置成功"];
        [CRFUserDefaultManager saveFinalGesture:gesture];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        NSLog(@"两次手势不匹配！");
        
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView {
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中

- (void)infoViewDeselectedSubviews {
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

- (void)closeCurrentPage {
    if (self.type == GestureVerifyTypeSettingNew) {
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        [gestureVc setType:GestureViewControllerTypeSetting];
        [self.navigationController pushViewController:gestureVc animated:YES];
    } else {
        if (self.type == GestureVerifyTypeLogin) {
            [CRFUserDefaultManager saveFinalGesture:nil];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.resultHandler) {
                self.resultHandler();
            }
        }];
    }
}

- (void)dealloc {
    [CRFNotificationUtils removeObserver:self];
}


@end
