//
//  CRFNewRechargeModel.m
//  crf_purse
//
//  Created by maomao on 2018/8/17.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFNewRechargeModel.h"
#import "NSString+CRF.h"
@implementation CRFNewRechargeModel
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    return [self yy_modelInitWithCoder:decoder];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self yy_modelEncodeWithCoder:encoder];
}
//-(NSString *)transferAmount{
//    NSString* amount = [NSString stringWithFormat:@"%.2f",_transferAmount.doubleValue/100];
//    return [NSString stringWithFormat:@"%@元",[amount formatMoney]];
//}
@end
