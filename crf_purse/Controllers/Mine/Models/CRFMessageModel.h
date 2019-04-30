//
//  CRFMessageModel.h
//  crf_purse
//
//  Created by maomao on 2017/7/27.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFMessageModel : NSObject <NSMutableCopying, NSCopying>
@property (nonatomic, copy) NSString *createTime;///<
@property (nonatomic, copy) NSString *content;///<
@property (nonatomic, copy) NSString *createName;///<
@property (nonatomic, copy) NSString *mes_id;///<
@property (nonatomic, copy) NSString *isRead;///< 1 未读。2已读
@property (nonatomic, copy) NSString *pushTime;///<
@property (nonatomic, copy) NSString *status;///<
@property (nonatomic, copy) NSString *subject;///<
@property (nonatomic, copy) NSString *type;///<
@property (nonatomic, copy) NSString *updateName;///<
@property (nonatomic, copy) NSString *updateTime;///<
@property (nonatomic, assign)BOOL     isSelected;
@end
