//
//  CRFInvestFilterView.h
//  crf_purse
//
//  Created by maomao on 2017/11/9.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef NS_ENUM(NSInteger ,FilterType) {
//    Profit_asc  = 1,
//    Profit_dec  = 2,
//    Remain_asc  = 3,
//    Remain_dec  = 4,
//};
#define  kFilterViewHeight    44
@class CRFStatusButton;
@protocol CRFInvestFilterViewDelegate <NSObject>
-(void)filterProductWithType:(NSString*)type;
-(void)filterProductPayType:(NSString*)type IsMonthSelected:(BOOL)isSelected AndBedueSelected:(BOOL)dueSelected;
@end

@interface CRFInvestFilterView : UIView
@property (nonatomic ,strong) CRFStatusButton *profitButton;
@property (nonatomic ,strong) CRFStatusButton *daysButton;
@property (nonatomic ,strong) UIButton        *payMonthBtn;
@property (nonatomic ,strong) UIButton        *payExpireBtn;
@property (nonatomic ,strong) NSString        *filterType;
@property (nonatomic ,weak) id<CRFInvestFilterViewDelegate> filterDelegate;
-(void)crfTopLineHidden:(BOOL)isHidden;
@end
typedef NS_ENUM(NSInteger,StatusType){
    UnSelected = 0,
    SelectedUp = 1,
    SelectedDown = 2,
};
@interface CRFStatusButton:UIButton
@property (nonatomic , assign) StatusType  statusType;
//+(CRFStatusButton*)createBorderButton;
@end
