//
//  CRFTextView.h
//  crf_purse
//
//  Created by maomao on 2017/7/28.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CRFTextViewFinishBlock)(NSString *text);
typedef void(^CRFTextViewTextChangeBlock)();
@interface CRFTextView : UITextView
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) NSInteger maxTextLength;  /**< 最多字数 */

@property (nonatomic, copy) CRFTextViewFinishBlock finishBlock;
@property (nonatomic, copy) dispatch_block_t mm_didEdit;
@property (nonatomic, copy) CRFTextViewTextChangeBlock changeBlock;
@end
