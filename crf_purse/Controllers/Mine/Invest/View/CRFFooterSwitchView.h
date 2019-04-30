//
//  CRFFooterSwitchView.h
//  crf_purse
//
//  Created by maomao on 2018/6/21.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFLabel.h"
typedef void (^PushBlock) (NSString *url);
typedef void (^HelpBlock) ();
typedef void (^SwitchBlock) ();
@interface CRFFooterSwitchView : UIView
@property (nonatomic ,copy) HelpBlock helpBlock;
@property (nonatomic ,copy) SwitchBlock switchBlock;
@property (nonatomic ,copy) PushBlock pushBlock;;
@property (nonatomic ,strong) UIButton  *switchBtn;

@property (nonatomic ,strong) UILabel  *titleLabel;
@property (nonatomic ,strong) UILabel  *linkLabel;
@property (nonatomic ,assign) CGFloat  LinkHeight;

/**
 key:name, url, info
 */
@property (nonatomic, strong) NSArray *protocolArr;
//-(void)setBtnTitle:(NSString*)title;
-(void)updateLabelTitleString:(NSString*)title;
@end
