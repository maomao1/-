//
//  CRFBankNoTextField.h
//  crf_purse
//
//  Created by xu_cheng on 2017/10/16.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFBankNoTextField : UITextField

/**
 是否是粘贴
 */
@property (nonatomic, assign) BOOL pasteFlag;

/**
 粘贴的回调
 */
@property (nonatomic, copy) void (^(pasteHandler))(CRFBankNoTextField *textField);

@end
