//
//  CRFParserNetworkResponse.m
//  crf_purse
//
//  Created by xu_cheng on 2017/12/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFParserNetworkResponse.h"
#import "CRFRefreshTokenTool.h"
#import "CRFControllerManager.h"
#import "CRFNoticeView.h"
#import "CRFAlertUtils.h"
#import "JCAlertView.h"
#import "AppDelegate.h"
@implementation CRFDataModel
@end
@interface CRFParserNetworkResponse()

@property (nonatomic, strong) NSDictionary *messageDict;

@property (nonatomic, strong) CRFNoticeView *noticeView;

@end

@implementation CRFParserNetworkResponse

- (CRFNoticeView *)noticeView {
    if (!_noticeView) {
        _noticeView = [CRFNoticeView new];
    }
    return _noticeView;
}

- (NSDictionary *)messageDict {
    if (!_messageDict) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ErrorMessage" ofType:@"plist"];
        _messageDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return _messageDict;
}

+ (instancetype)sharedInstance {
    static CRFParserNetworkResponse *parser = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        parser = [[self alloc] init];
    });
    return parser;
}


+ (void)parserRefreshTokenResponseError:(NSError *)error failed:(CRFNetworkFailedBlock)failedHandler {
    NSHTTPURLResponse *responseInternal = error.userInfo[kErrorCodekey];
    DLog(@" error code is %ld", (long)responseInternal.statusCode);
    if (responseInternal.statusCode == 400) {
        id data = error.userInfo[kErrorDataKey];
        id oj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //刷新失败，判断是否是登录异常，YES：弹窗，NO：直接callback
        if ([self tokenException:oj]) {
            [CRFLoadingView dismiss];
            [CRFControllerManager receivePushMessage:oj[kMessageKey] confirmTitle:@"重新登录"];
        } else {
            [self parserErrorException:error statusCode:responseInternal.statusCode failed:failedHandler];
        }
    }
}

+ (void)parserResponseError:(NSError *)error target:(id)target originSelecter:(SEL)originSelector paragram:(NSArray *)paragrams failed:(CRFNetworkFailedBlock)failedHandler {
    NSHTTPURLResponse *responseInternal = error.userInfo[kErrorCodekey];
    DLog(@" error code is %ld", (long)responseInternal.statusCode);
    if (responseInternal.statusCode == 400) {
        id data = error.userInfo[kErrorDataKey];
        id oj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [CRFUtils getMainQueue:^{
            //是否是刷新token的code
            if ([oj[@"code"] isEqualToString:@"FUS_2000"]) {
                [CRFRefreshTokenTool refreshToken:^(CRFNetworkCompleteType errorType, id  _Nullable response, id _Nullable refreshTarget) {
                    //刷新成功，将消息转发
                    [self messageSendWithResponse:response target:refreshTarget paragrams:paragrams originSelector:originSelector failed:failedHandler];
                } failed:^(CRFNetworkCompleteType errorType, NSError * _Nullable response) {
                    [[CRFStandardNetworkManager defaultManager] cancelAll];
                    if ([response isKindOfClass:[NSDictionary class]]) {
                        if (failedHandler) {
                            failedHandler(CRFNetworkCompleteTypeFailure,response);
                        }
                        return ;
                    }
                    NSHTTPURLResponse *tokenResponseInternal = response.userInfo[kErrorCodekey];
                    if (tokenResponseInternal.statusCode == 400) {
                        id tokenData = response.userInfo[kErrorDataKey];
                        id tokenOj = [NSJSONSerialization JSONObjectWithData:tokenData options:NSJSONReadingMutableContainers error:nil];
                        //刷新失败，判断是否是登录异常，YES：弹窗，NO：直接callback
                        if ([self tokenException:tokenOj]) {
                            [CRFLoadingView dismiss];
                            [CRFControllerManager receivePushMessage:tokenOj[kMessageKey] confirmTitle:@"重新登录"];
                        } else {
                            [self parserErrorException:tokenOj statusCode:tokenResponseInternal.statusCode failed:failedHandler];
                        }
                    } else {
                        [self parserErrorException:response statusCode:tokenResponseInternal.statusCode failed:failedHandler];
                    }
                } target:target originSelector:originSelector params:paragrams];
                return ;
            }else if ([oj[@"code"] isEqualToString:@"FAPP_9981"]) {
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.apiNum += 1;
                if (delegate.apiNum>2) {
                    return;
                }
                CRFDataModel *dataModel = [CRFDataModel yy_modelWithDictionary:oj];
                CRFAppHomeModel *model = [CRFAppHomeModel yy_modelWithJSON:[dataModel.message formatJsonStirng]];
//                [CRFAlertUtils showAlertLeftTitle:model.title AttributedMessage:[CRFStringUtils changedLineSpaceWithTotalString:model.content lineSpace:3] Time:model.time container:[CRFUtils getVisibleViewController] cancelTitle:nil confirmTitle:@"立即前往" cancelHandler:nil confirmHandler:^{
//                    if (model.jumpUrl.length) {
//                        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: model.jumpUrl]];
//                        exit(0);
//                    }
//                }];
                [CRFAlertUtils showAlertMessage:[CRFStringUtils changedLineSpaceWithTotalString:model.content lineSpace:3] container:[CRFUtils getVisibleViewController] cancelTitle:nil confirmTitle:@"立即前往" cancelHandler:nil confirmHandler:^{
                    if (model.jumpUrl.length) {
                        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: model.jumpUrl]];
                        exit(0);
                    }
                }];
            }
            else if ([oj[@"code"] isEqualToString:@"FAPP_9999"]){
                [CRFLoadingView dismiss];
                [CRFAlertUtils showAlertTitle:oj[kMessageKey] container:[CRFUtils getVisibleViewController] cancelTitle:@"取消" confirmTitle:@"登录" cancelHandler:nil confirmHandler:^{
                    CRFLoginViewController *controller = [CRFLoginViewController new];
                    controller.popType = PopFrom;
                    controller.hidesBottomBarWhenPushed = YES;
                    [[CRFUtils getVisibleViewController].navigationController pushViewController:controller animated:YES];
                }];
            }
            else {
                //判断该错误是否是登录异常，YES：弹窗，NO：直接callback
                if ([self tokenException:oj]) {
                    [CRFLoadingView dismiss];
                    [CRFControllerManager receivePushMessage:oj[kMessageKey] confirmTitle:@"重新登录"];
                } else {
                     [self parserErrorException:oj statusCode:responseInternal.statusCode failed:failedHandler];
                }
            }
        }];
    } else {
        //如果不是400，报错
        [self parserErrorException:error statusCode:responseInternal.statusCode failed:failedHandler];
    }
}

/**
 消息转发
 
 @param aSelector 原方法
 @param objects 原方法中的参数（不能为nil）
 @return object
 */
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects target:(id)target {
    NSMethodSignature *methodSignature = [[target class] instanceMethodSignatureForSelector:aSelector];
    if(methodSignature == nil) {
        @throw [NSException exceptionWithName:@"抛异常错误" reason:@"没有这个方法，或者方法名字错误" userInfo:nil];
        return nil;
    } else {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:target];
        [invocation setSelector:aSelector];
        //签名中方法参数的个数，内部包含了self和_cmd，所以参数从第3个开始
        NSInteger  signatureParamCount = methodSignature.numberOfArguments - 2;
        NSInteger requireParamCount = objects.count;
        NSInteger resultParamCount = MIN(signatureParamCount, requireParamCount);
        for (NSInteger i = 0; i < resultParamCount; i++) {
            id  obj = objects[i];
            [invocation setArgument:&obj atIndex:i+2];
        }
        [invocation invoke];
        //返回值处理
        id callBackObject = nil;
        if(methodSignature.methodReturnLength) {
            [invocation getReturnValue:&callBackObject];
        }
        return callBackObject;
    }
}

/**
 token刷新后，response的处理
 
 @param response response
 @param paragrams paragrams
 @param originSelector 原方法
 @param failedHandler failedHandler
 */
+ (void)messageSendWithResponse:(id)response target:(id)target paragrams:(NSArray *)paragrams originSelector:(SEL)originSelector failed:(CRFNetworkFailedBlock)failedHandler {
    if ([response[kResult] isEqualToString:kSuccessResultStatus]) {
        NSLog(@"==origin paraagrams is  %@==",paragrams);
        if ([target respondsToSelector:originSelector]) {
            [[CRFParserNetworkResponse sharedInstance] performSelector:originSelector withObjects:paragrams target:target];
        }
    } else {
        if (failedHandler) {
            failedHandler(CRFNetworkCompleteTypeFailure,response);
        }
    }
}


/**
 解析失败的response
 
 @param error error
 @param statusCode statusCode
 @param failedHandler failedHandler
 */
+ (void)parserErrorException:(NSError *)error statusCode:(NSInteger)statusCode failed:(CRFNetworkFailedBlock)failedHandler {
    //弹出公告
    if (statusCode == 503) {
        [[CRFParserNetworkResponse sharedInstance].noticeView show];
        return;
    }
    if (statusCode == 400) {
        if (failedHandler) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                failedHandler(CRFNetworkCompleteTypeFailure,error);
            } else { failedHandler(CRFNetworkCompleteTypeFailure,@{kMessageKey:NSLocalizedString(@"toast_network_online_error", nil)});
            }
        }
        return;
    }
    if (![[CRFParserNetworkResponse sharedInstance].messageDict.allKeys containsObject:[NSString stringWithFormat:@"%ld",statusCode]]) {
        DLog(@"request error is %@",error.description);
        if (failedHandler) {
            failedHandler(CRFNetworkCompleteTypeFailure,@{kResult:@"-1",kMessageKey:NSLocalizedString(@"toast_network_online_error", nil)});
        }
    } else {
        NSDictionary *dict = @{kResult:[NSString stringWithFormat:@"%ld",statusCode],kMessageKey:[[CRFParserNetworkResponse sharedInstance].messageDict objectForKey:[NSString stringWithFormat:@"%ld",statusCode]]};
        if (failedHandler) {
            failedHandler(CRFNetworkCompleteTypeFailure,dict);
        }
    }
}

/**
 token异常
 
 @param dict response
 @return bool
 */
+ (BOOL)tokenException:(NSDictionary *)dict {
    NSLog(@"token 异常===%@",dict);
    if ([dict[@"code"] isEqualToString:@"FUS_2000"] ||
        [dict[@"code"] isEqualToString:@"FUS_2001"] ||
        [dict[@"code"] isEqualToString:@"FUS_2002"] ||
        [dict[@"code"] isEqualToString:@"FUS_2004"] ||
        [dict[@"code"] isEqualToString:@"FUS_2005"] ||
        [dict[@"code"] isEqualToString:@"FUS_2006"] ||
        [dict[@"code"] isEqualToString:@"FUS_2007"] ||
        [dict[@"code"] isEqualToString:@"FUS_2008"] ||
        [dict[@"code"] isEqualToString:@"FUS_2009"] ||
        [dict[@"code"] isEqualToString:@"FUS_2010"] ||
        [dict[@"code"] isEqualToString:@"FUS_2011"] ) {
        return YES;
    }
    return NO;
}


@end
