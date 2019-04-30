//
//  CRFBorrowerInfoModel.h
//  crf_purse
//
//  Created by mystarains on 2018/11/29.
//  Copyright © 2018 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRFBorrowerInfoModel : NSObject

@property (nonatomic, copy) NSString *capitalUseCase;     ///<资金运作情况
@property (nonatomic, copy) NSString *income;             ///<
@property (nonatomic, copy) NSString *industry;           ///<
@property (nonatomic, copy) NSString *interestDate;       ///<起息日期
@property (nonatomic, copy) NSString *isLoanSituation;    ///<
@property (nonatomic, copy) NSString *liabilitiesType;    ///<
@property (nonatomic, copy) NSString *loanAmount;         ///<
@property (nonatomic, copy) NSString *loanContractNo;     ///<借款合同号
@property (nonatomic, copy) NSString *loanPurpose;        ///<
@property (nonatomic, copy) NSString *loanTerm;           ///<
@property (nonatomic, copy) NSString *loanYearRate;       ///<
@property (nonatomic, copy) NSString *overdueType;        ///<
@property (nonatomic, copy) NSString *repaySecurity;      ///<还款保障措施
@property (nonatomic, copy) NSString *repaySource;        ///<起息来源
@property (nonatomic, copy) NSString *repayType;          ///<还款方式
@property (nonatomic, copy) NSString *riskLevel;          ///<风险等级
@property (nonatomic, copy) NSString *subjectType;        ///<


@end

NS_ASSUME_NONNULL_END
