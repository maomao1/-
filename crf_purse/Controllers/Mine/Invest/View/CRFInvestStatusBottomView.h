//
//  CRFInvestStatusBottomView.h
//  crf_purse
//
//  Created by xu_cheng on 2018/3/16.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 出资详情可操作的状态

 - CRFProductStatusCanRedeemAndShiftInInvestment: 可转投、可退出
 - CRFProductStatusAppointmentInShiftInInvestment: 可预约转投
 - CRFProductStatusViewAppointmentInShiftInInvestmentInfo: 可查看转投详情
 */
typedef NS_ENUM(NSUInteger, CRFProductStatus) {
    CRFProductStatusCanRedeemAndShiftInInvestment           = 0,
    CRFProductStatusAppointmentInShiftInInvestment          = 1,
    CRFProductStatusViewAppointmentInShiftInInvestmentInfo  = 2,
    CRFProductStatusAutoInvest                              = 3,
    CRFProductStatusViewAutoInvestInfo                      = 4,
};

@interface CRFInvestStatusBottomView : UIView


- (instancetype)initWithProductStatus:(CRFProductStatus)productStatus eventHandler:(void (^)(CRFProductStatus status, NSInteger index))eventHandler;

- (void)setEnable:(BOOL)enable;

@end
