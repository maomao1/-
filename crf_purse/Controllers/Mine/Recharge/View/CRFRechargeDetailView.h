//
//  CRFRechargeDetailView.h
//  crf_purse
//
//  Created by maomao on 2018/8/20.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFBasicView.h"
#import "CRFNewRechargeModel.h"
@interface CRFRechargeDetailView : CRFBasicView
@property (nonatomic ,strong)  CRFNewRechargeModel *rechargeInfo;

-(void)show;
@end
