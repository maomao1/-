//
//  CRFNewRechargeModel.h
//  crf_purse
//
//  Created by maomao on 2018/8/17.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFNewRechargeModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *chgCd;        ///< 充值码
@property (nonatomic, copy) NSString *chgDt;        ///< 生成时间
@property (nonatomic, copy) NSString *fcpTrxNo;     ///< 请求流水号
@property (nonatomic, copy) NSString *fyAccNm;      ///< 入账户名
@property (nonatomic, copy) NSString *fyAccNo;      ///< 入账卡号
@property (nonatomic, copy) NSString *fyBank;       ///< 入账银行
@property (nonatomic, copy) NSString *fyBankBranch; ///< 支行信息
@property (nonatomic, copy) NSString *transferAmount; ///< 
@property (nonatomic, copy) NSString *uuid;
@end
