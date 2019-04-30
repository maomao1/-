//
//  CRFRedeemView.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/21.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CRFRedeemViewDelegate;

@interface CRFRedeemView : UIView
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (nonatomic, copy) NSString *accountAmount;

@property (nonatomic,weak) id <CRFRedeemViewDelegate> delegate;

- (void)addView:(UIView *)view;
- (void)show;
- (void)hidden;

@end

@protocol CRFRedeemViewDelegate <NSObject>

- (void)ransom:(NSString *)code;

@end
