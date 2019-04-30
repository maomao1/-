//
//  CRFReceiveCashModel.h
//  crf_purse
//
//  Created by maomao on 2019/4/25.
//  Copyright © 2019年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CRFReceiveCashDetail;
@interface CRFReceiveCashDetail : NSObject
@property (nonatomic ,copy) NSString      * cashAmount;           ///<
@property (nonatomic ,copy) NSString      * clearingNo;
@property (nonatomic ,copy) NSString      * endDate;           ///<
@property (nonatomic ,copy) NSString      * expiringDate;
@property (nonatomic ,copy) NSString      * startDate;           ///<
@end
@interface CRFReceiveCashModel : NSObject
@property (nonatomic ,copy) NSString      * receivedcash;           ///<
@property (nonatomic ,copy) NSString      * uncollectedcash;        ///<
@property (nonatomic ,copy) NSArray       * detail;
@end

NS_ASSUME_NONNULL_END
