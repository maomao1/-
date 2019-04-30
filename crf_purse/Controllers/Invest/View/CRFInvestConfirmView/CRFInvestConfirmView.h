//
//  CRFInvestConfirmView.h
//  crf_purse
//
//  Created by maomao on 2017/11/17.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFProductModel.h"
typedef void (^CRFInvestConfirmViewConfirmBlock)();
typedef void (^CRFInvestConfirmViewAgainChoseBlock)();

@interface CRFInvestConfirmView : UIView
@property (nonatomic ,copy) CRFInvestConfirmViewConfirmBlock confirmBlock;
@property (nonatomic ,copy) CRFInvestConfirmViewAgainChoseBlock againChoseBlock;
@property (nonatomic ,strong) NSArray *btnTitles;
-(void)setContentWithModel:(CRFProductModel*)item AndInvestAmount:(NSString *)amount;
- (void)showInView:(UIView*)view;
-(void)setRiskLimitContent;
@end
