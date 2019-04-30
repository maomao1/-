//
//  CRFAboutCell.h
//  crf_purse
//
//  Created by maomao on 2017/7/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
static  NSString *const  CRFAboutCell_ID = @"CRFAboutCell_ID";
static  NSString *const  CRFMoreSettingCell_ID = @"CRFMoreSettingCell_ID";
@interface CRFAboutTableViewCell : UITableViewCell
@property  (nonatomic,strong) UILabel  *titleLabel;
@property  (nonatomic,strong) UILabel  *versionLabel;
@property  (nonatomic,strong) UILabel  *versionRed;
@property  (nonatomic,assign) BOOL      isCanSet;

@property  (nonatomic, strong)UISwitch *mm_switch;


@property (nonatomic, strong) UIView *view;

@property (nonatomic, copy) void (^(switchHandler))(UISwitch *control);



@end
