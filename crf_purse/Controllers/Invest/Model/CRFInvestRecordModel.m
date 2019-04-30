//
//  CRFInvestRecordModel.m
//  crf_purse
//
//  Created by maomao on 2017/7/26.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFInvestRecordModel.h"
#import "CRFTimeUtil.h"
@implementation CRFInvestRecordModel
/*@property (nonatomic , copy)  NSString  *createTime;
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
 */

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    return [self yy_modelInitWithCoder:decoder];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self yy_modelEncodeWithCoder:encoder];
}



//- (NSString *)content{
//    return [NSString stringWithFormat:@"%@ %@ %@出资%@元",_mobilePhone,_investorName,_productName,_lendAmount];
//}

- (NSString *)hidePhoneNum{
    if (_mobilePhone.length>9) {
        _hidePhoneNum = [_mobilePhone stringByReplacingCharactersInRange:NSMakeRange(3, 6) withString:@"******"];
    }
    return _hidePhoneNum;
}
- (NSString *)lendAmount{
//    if (_lendAmount.length > 4) {
//        return [NSString stringWithFormat:@"%@万", [[_lendAmount substringWithRange:NSMakeRange(0, _lendAmount.length - 4)] formatBeginMoney]];
//    }
    if (!_lendAmount) {
        _lendAmount = @"0";
    }
    return [_lendAmount formatMoney];
}
- (NSString *)timeShowStr{
    long long timeInter = ([CRFTimeUtil getCurrentTimeInteveral] - [_createTime longLongValue])/1000;
    NSInteger hour = (NSInteger)timeInter / 3600;
    NSInteger minute = (NSInteger)(timeInter - 3600 * (long long)hour) / 60;
//    NSInteger second = (timeInter - 3600 * hour - 60 * minute);
    if (hour>24) {
        return [NSString stringWithFormat:@"%ld天前",hour/24];
    }else if (hour > 0) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hour];
    }else if (hour == 0 && minute > 0) {
        return [NSString stringWithFormat:@"%ld分钟前",(long)minute];
    }else{
        return nil;
    }
}
- (NSMutableAttributedString *)setContentAttributedStringShow{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.mobilePhone]];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, self.mobilePhone.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0xFF7E5B) range:NSMakeRange(0, self.mobilePhone.length)];
    return attributedStr;
}
@end
