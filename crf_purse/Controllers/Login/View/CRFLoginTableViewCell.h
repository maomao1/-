//
//  CRFLoginTableViewCell.h
//  CRFWallet
//
//  Created by xu_cheng on 2017/6/20.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFTextField.h"

@interface CRFLoginTableViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CRFTextField *textField;
- (void)cellLeftImgName:(NSString *)imageName placeholder:(NSString *)placeholder editCompleteCallback:(void (^)(NSString *content))completeCallback;

@end
