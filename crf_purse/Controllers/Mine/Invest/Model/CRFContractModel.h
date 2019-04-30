//
//  CRFContractModel.h
//  crf_purse
//
//  Created by shlpc1351 on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFContractModel : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *day;
@property(nonatomic,copy) NSString *percent;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *num;
@property(nonatomic,copy) NSString *loanMoney;
@property(nonatomic,copy) NSString *switchMoney;
@property(nonatomic,copy) NSString *imageName1;
@property(nonatomic,copy) NSString *imageName2;
@property(nonatomic,assign) BOOL status;

@end
