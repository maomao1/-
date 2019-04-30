//
//  CRFDataSourceFactory.m
//  crf_purse
//
//  Created by xu_cheng on 2018/1/9.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFDataSourceFactory.h"

@implementation CRFDataSourceFactory

+ (NSArray<NSArray *> *)factoryInvestDetailDataSource:(NSInteger)source productType:(NSInteger)productType status:(NSInteger)status{
    NSArray *titles = nil;
    NSArray *images = nil;
    switch (status) {
        case 0: {
            if (source == 2 && productType != 4) {
                titles = @[];
                images = @[];
            } else {
#ifdef WALLET
                if (![CRFUtils normalUser]) {
                    titles = @[];
                    images = @[];
                } else{
                    titles = @[@"出借人服务协议"];
                    images = @[[UIImage imageNamed:@"service_protocol_icon"]];
                }
#else
                titles = @[@"出借人服务协议"];
                images = @[[UIImage imageNamed:@"service_protocol_icon"]];
#endif
               
            }
        }
            break;
        case 1: {
            if (source == 2 && productType != 4) {
#ifdef WALLET
                if (![CRFUtils normalUser]) {
                    titles = @[@"资金退出记录",@"投资账单"];
                    images = @[[UIImage imageNamed:@"invest_record_icon"],[UIImage imageNamed:@"invest_order_icon"]];
                } else {
                    
                    titles = @[@"资金退出记录",@"出借账单",@"债权明细",@"分月回款明细"];
                    images =@[[UIImage imageNamed:@"invest_record_icon"],[UIImage imageNamed:@"invest_order_icon"],[UIImage imageNamed:@"invest_detail_icon"]];
                }
#else
                titles = @[@"资金退出记录",@"出借账单",@"债权明细",@"分月回款明细"];
                images = @[[UIImage imageNamed:@"invest_record_icon"],[UIImage imageNamed:@"invest_order_icon"],[UIImage imageNamed:@"invest_detail_icon"],[UIImage imageNamed:@"return_money_icon"]];
#endif
            } else {
#ifdef WALLET
                if (![CRFUtils normalUser]) {
                    titles = @[@"投资账单"];
                    images = @[[UIImage imageNamed:@"invest_order_icon"]];
                } else {
                    titles = @[@"出借人服务协议",@"出借账单",@"债权明细",@"分月回款明细"];
                    images =@[[UIImage imageNamed:@"service_protocol_icon"],[UIImage imageNamed:@"invest_order_icon"],[UIImage imageNamed:@"invest_detail_icon"],[UIImage imageNamed:@"return_money_icon"]];
                }
#else
                titles = @[@"出借人服务协议",@"出借账单",@"债权明细",@"分月回款明细"];
                images =@[[UIImage imageNamed:@"service_protocol_icon"],[UIImage imageNamed:@"invest_order_icon"],[UIImage imageNamed:@"invest_detail_icon"],[UIImage imageNamed:@"return_money_icon"]];
                
#endif
            }
        }
            break;
        case 2: {
            if (source == 2 && productType != 4) {
                titles = @[@"资金退出记录",@"出借账单",@"分月回款明细"];
                images = @[[UIImage imageNamed:@"invest_record_icon"],[UIImage imageNamed:@"invest_order_icon"],[UIImage imageNamed:@"return_money_icon"]];
                
            } else {
#ifdef WALLET
                if (![CRFUtils normalUser]) {
                    titles = @[@"出借账单",@"分月回款明细"];
                    images = @[[UIImage imageNamed:@"invest_order_icon"],[UIImage imageNamed:@"return_money_icon"]];
                } else {
                    titles = @[@"出借人服务协议",@"出借账单",@"分月回款明细"];
                    images = @[[UIImage imageNamed:@"service_protocol_icon"],[UIImage imageNamed:@"invest_order_icon"],[UIImage imageNamed:@"return_money_icon"]];
                }
#else
                titles = @[@"出借人服务协议",@"出借账单",@"分月回款明细"];
                images = @[[UIImage imageNamed:@"service_protocol_icon"],[UIImage imageNamed:@"invest_order_icon"],[UIImage imageNamed:@"return_money_icon"]];
#endif
                
            }
        }
            break;
    }
    return @[titles,images];
    
}

@end
