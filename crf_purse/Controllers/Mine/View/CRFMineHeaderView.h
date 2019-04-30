//
//  CRFMineHeaderView.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/22.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicView.h"

typedef NS_ENUM(NSUInteger, UserStatus) {
    On_line          = 0,
    Off_line         = 1,
};

@protocol HeaderViewDelegate;

@interface CRFMineHeaderView : CRFBasicView
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *totalAmountlabel;
@property (strong, nonatomic) UILabel *profitLabel;
@property (strong, nonatomic) UILabel *variableLabel;
@property (strong, nonatomic) UIButton *secretButton;

@property (nonatomic, assign) UserStatus userStatus;

@property (nonatomic, strong) CRFAccountInfo *accountInfo;

@property (nonatomic, weak) id <HeaderViewDelegate> headerDelegate;

- (void)refreshImageView;

@end


@protocol HeaderViewDelegate <NSObject>

- (void)userInfo;

- (void)userTransform;

- (void)userRecharge;

-(void)explainHelpView;


@end
