//
//  CRFInvestRecordModel.h
//  crf_purse
//
//  Created by maomao on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFInvestRecordModel : NSObject <NSCoding>
@property (nonatomic , copy)  NSString  *createTime;
@property (nonatomic , copy)  NSString  *headImgUrl;
@property (nonatomic , copy)  NSString  *investDate;
@property (nonatomic , copy)  NSString  *investNo;
@property (nonatomic , copy)  NSString  *investorName;
@property (nonatomic , copy)  NSString  *lendAmount;
@property (nonatomic , copy)  NSString  *mobilePhone;
@property (nonatomic , copy)  NSString  *productName;

//
@property (nonatomic , copy)NSString  *hidePhoneNum;///<隐藏后的手机号
@property (nonatomic , copy)NSString  *timeShowStr; ///<界面显示的时间
//@property (nonatomic , copy)NSString  *content;     ///<显示的文本内容

- (NSMutableAttributedString*)setContentAttributedStringShow;
@end
