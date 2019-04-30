//
//  CRFTextField.h
//  crf_purse
//
//  Created by xu_cheng on 2017/8/8.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFTextField : UITextField

/**
 是否禁止复制粘贴
 */
@property (nonatomic, assign) BOOL hiddenMenu;

/**
 输入最大长度
 */
@property (nonatomic ,assign) NSInteger maxCount;
@end
