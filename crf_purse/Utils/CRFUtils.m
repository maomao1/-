//
//  CRFUtils.m
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/19.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "UIImage+Color.h"
#import "CRFToast.h"
#import "CRFTimeUtil.h"

@implementation CRFUtils

+(BOOL)validateCurrentMobileSystem10_2{
    NSString *str = [[UIDevice currentDevice] systemVersion];
    if ([str compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str compare:@"10.2" options:NSNumericSearch] == NSOrderedSame) {
        return YES;
    }
    return NO;
}
+ (BOOL)isIPhoneXAll {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

+ (UIFont *)fontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@".HelveticaNeueDeskInterface-Regular" size:size];
    if (!font) {
        font = [UIFont boldSystemFontOfSize:size];
    }
    return font;
}

+ (BOOL)isMaJiaBao {
    //com.crfchina.purseTest
    if ([[NSString getAppId] isEqualToString:@"com.crfchina.crfpurse"] ||[[NSString getAppId] isEqualToString:@"com.crfchina.purseTest"]) {
        return NO;
    }
    return YES;
}

+ (CGFloat)getStatusBarMargen {
    if ([self isIPhoneXAll]) {
        return 44;
    }
    return 20;
}

+ (CGFloat)getTabBarBottomMargen {
    if ([self isIPhoneXAll]) {
        return 34;
    }
    return 0;
}

+ (void)getMainQueue:(void (^)(void))callback {
    dispatch_async(dispatch_get_main_queue(), ^{
        callback();
    });
}

+ (BOOL)allowCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (NSString *)getDeviceUUId{
    return [CRFUserDefaultManager getDeviceUUID];
}

+ (BOOL)allowPhotos {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (UIViewController*)topMostWindowController {
    UIViewController *topController = [self rootViewController];

    //  Getting topMost ViewController
    while ([topController presentedViewController])    topController = [topController presentedViewController];

    //  Returning topMost ViewController
    return topController;
    
}

+ (UIViewController*)getVisibleViewController {
    UIViewController *currentViewController = [self topMostWindowController];
    if ([currentViewController isKindOfClass:[UITabBarController class]]) {
        currentViewController = ((UITabBarController *)currentViewController).selectedViewController;
    }
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}

+ (UIViewController *)rootViewController {
    return [[UIApplication sharedApplication].delegate window].rootViewController;
}

+ (void)showMessage:(NSString *)message {
    [self showMessage:message drution:1.5];
}

+ (void)showMessage:(NSString *)message drution:(CGFloat)time {
    [CRFToast showMessage:message drution:time];
}

+ (void)delayAfert:(int)second handle:(void(^)(void))handle {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        handle();
    });
}

+ (NSString *)getBankName:(NSString*)idCard {
    if(idCard==nil || idCard.length<16 || idCard.length>19){
        return nil;
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"plist"];
    NSDictionary* resultDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *bankBin = resultDic.allKeys;
    //6位Bin号
    NSString* cardbin_6 = [idCard substringWithRange:NSMakeRange(0, 6)];
    //8位Bin号
    NSString* cardbin_8 = [idCard substringWithRange:NSMakeRange(0, 8)];
    
    if ([bankBin containsObject:cardbin_6]) {
        return [resultDic objectForKey:cardbin_6];
    }else if ([bankBin containsObject:cardbin_8]){
        return [resultDic objectForKey:cardbin_8];
    }else{
        return nil;
    }
}

+ (CGSize)croppedImage:(UIImage *)croppedImage {
    CGSize originalSize =
    CGSizeMake(croppedImage.size.width, croppedImage.size.height);
    CGFloat scale = originalSize.width / 1300;
    CGSize newSize =
    CGSizeMake(originalSize.width / scale, originalSize.height / scale);
    return newSize;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (NSArray <CRFMyInvestProduct *>*)sortDatas:(NSArray <CRFMyInvestProduct *>*)datas type:(NSInteger)type  {
    NSArray *array = [datas sortedArrayUsingComparator:^NSComparisonResult(CRFMyInvestProduct *obj1, CRFMyInvestProduct *obj2) {
        if (type == 1) {
            if ([obj1.remainDays integerValue] < [obj2.remainDays integerValue]) {
                return NSOrderedAscending;
            } else if ([obj1.remainDays integerValue] > [obj2.remainDays integerValue]) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }
        return [[CRFTimeUtil getDateWithFormatDate:obj2.applyDate] compare:[CRFTimeUtil getDateWithFormatDate:obj1.applyDate]];
    }];
    return [array mutableCopy];
}

+ (NSArray <CRFMyInvestProduct *>*)sortDatas:(NSArray <CRFMyInvestProduct *>*)datas {
    NSArray *array = [datas sortedArrayUsingComparator:^NSComparisonResult(CRFMyInvestProduct *obj1, CRFMyInvestProduct *obj2) {
            return [[CRFTimeUtil getDateWithFormatDate:obj2.exitDate] compare:[CRFTimeUtil getDateWithFormatDate:obj1.exitDate]];
    }];
    return [array mutableCopy];
}

+ (NSInteger)isReturnFileVideo:(NSString *)string{
    if (string.length) {
        if ([string hasSuffix:@".mp4"]) {
            return 1;//video
        } else {
            return 2;//jpg
        }
    } else {
        return  0; // 空
    }
}

+ (CRFCouponModel *)selectedBestWithArray:(NSArray*)couponArray ForMoney:(NSString*)amount AndFreezid:(NSInteger)freezid days:(NSInteger)days type:(BOOL)type {
//    NSMutableArray *array = [NSMutableArray new];
//    NSMutableArray *array1 =[NSMutableArray new];
    CRFCouponModel *resultModel=[CRFCouponModel new];
    resultModel.giftName = @"选择返现／加息红包";
    resultModel.giftValue=@"0";
    for (CRFCouponModel *model in couponArray) {
        DLog(@"%@",model.useRuleItem);
       CRFCouponRule *ruleModel =[CRFCouponRule yy_modelWithJSON:model.useRuleItem];
         DLog(@"%@",ruleModel);
        if (ruleModel.lowerLimitAmount.doubleValue<=[amount getOriginString].doubleValue && ruleModel.days.doubleValue <=freezid && (ruleModel.upperLimitDays.doubleValue>freezid||!ruleModel.upperLimitDays.length)) {
            if (model.giftType.integerValue == 1|| model.giftType.integerValue == 2) {
                if (resultModel.giftValue&& resultModel.giftValue.doubleValue<model.giftValue.doubleValue) {
                    resultModel = model;
                }
            }else if (model.giftType.integerValue ==3){

                double giftValue = [self incomeAmount:amount yInterestRate:model.giftValue day:freezid NCP:days == 365 type:type];
                double resultValue = [self incomeAmount:amount yInterestRate:resultModel.giftValue day:freezid NCP:days == 365 type:type];
                if (giftValue>model.maxAmount.doubleValue) {
                    giftValue = model.maxAmount.doubleValue;
                }
                if (resultModel.giftValue&&resultValue<giftValue) {
                    resultModel = model;
                }
            }else{
                DLog(@"优惠券类型未知，出现1，2，3之外情况，%@",model.giftType);
            }
        }
    }
//    CRFCouponModel *model = [CRFCouponModel new];
//    model.giftName = @"200元优惠券";
    return  resultModel;
}

+ (BOOL)normalUser {
#ifdef WALLET
    if ([[CRFAppManager defaultManager].userInfo.phoneNo isEqualToString:kTestMoblePhone]) {
        return NO;
    }
    if ([CRFAppManager defaultManager].majiabaoFlag && [[CRFAppManager defaultManager].userInfo.phoneNo isEqualToString:kTestMoblePhone]) {
        return NO;
    }
    return YES;
#else
    return YES;
#endif
}

+ (BOOL)applying {
    return ([CRFAppManager defaultManager].majiabaoFlag);
}

+ (CGFloat)incomeAmount:(NSString *)amount yInterestRate:(NSString *)yInterestRate day:(NSInteger)day NCP:(BOOL)NCP type:(BOOL)type {
    /*
     连盈
     期望收益 = ((期望年化复利收益率 + 1)^(计息天数/365) -1) * 初始本金
     其中：
     “计息天数”=“出借天数” - 1
    */
    
    if (type) {
        return (pow((yInterestRate.doubleValue / 100 + 1), day / (NCP?365.0:360.0)) - 1) * [amount getOriginString].doubleValue;
    } else {
        /*
         月盈
        预期总收益（月盈） = 年化复利收益率 * 计息天数 * 初始本金 / 365
         其中：
         “计息天数”=“出借天数” - 1
         */
        return ([[amount getOriginString] doubleValue] * day * [yInterestRate doubleValue] / 100) / (NCP?365:360);
    }
    
//   return ([[amount getOriginString] doubleValue] * day * [yInterestRate doubleValue] / 100) / (NCP?365:360);
}

+ (NSString *)getFailedmessage {
    return [NSString stringWithFormat:@"账号：%@,时间：%@",kUserInfo.phoneNo, [CRFTimeUtil getCurrentDate]];
}

+ (UIImage *)loadImageResource:(NSString *)imageNamed {
    UIImage *image = nil;
    if ([CRFAppManager defaultManager].needReloadIcon) {
        image = [UIImage imageWithContentsOfFile:[[CRFAppManager defaultManager].resourcePath stringByAppendingPathComponent:imageNamed]];
    }
    if (!image) {
        image = [UIImage imageNamed:imageNamed];
    }
    return image;
}

+ (BOOL)complianceProduct:(NSString *)source {
     return [source isEqualToString:@"NCP"];
}

+(NSDictionary*)dictionaryWithJsonString:(NSString*)jsonString {
    if(jsonString ==nil) {
        return nil;
    }
    NSData*jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError*err;
    NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingMutableContainers
                                                        error:&err];
    if(err) {
        DLog(@"json解析失败：%@",err);
        return nil;
    }
    NSMutableDictionary*newdict=[[NSMutableDictionary alloc]init];
    for(NSString*keys in dic)
    {
        if(dic[keys]==[NSNull null])
        {
            [newdict setObject:@" "forKey:keys];
            continue;
        }
         [newdict setObject:[NSString stringWithFormat:@"%@",dic[keys]]forKey:keys];
    }
    return newdict;
}
@end
