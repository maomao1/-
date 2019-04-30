//
//  CRFInvestStatusTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFProductDetail.h"
#import <YYImage/YYAnimatedImageView.h>
@protocol CRFInvestStatusTableViewCellDelegate <NSObject>
-(void)showProfitExplainViewIsEnd:(BOOL)isEnd;
@end
@interface CRFInvestStatusTableViewCell : UITableViewCell
@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, strong) CRFProductDetail *product;

@property (nonatomic, assign) NSInteger days;

@property (nonatomic, assign) NSInteger waitDays;

@property (nonatomic, assign) BOOL hideBottomLine;



@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, weak) id<CRFInvestStatusTableViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger dynamicType;

@property (nonatomic, strong) CRFMyInvestProduct *originProduct;

@property (nonatomic, strong) CRFProductDetail *autoInvestProduct;

@property (nonatomic, strong) NSObject *autoInvestDynamicInfo;

@property (nonatomic, copy) void (^ (investDynamicHelpHandler))(void);

@property (nonatomic,strong) CRFProductDetail *endInvestProduct;

@property (nonatomic,assign) BOOL isAppointmentForward;

- (void)setAccessoryImageView;

- (void)setAccessoryViewNone;


@end


