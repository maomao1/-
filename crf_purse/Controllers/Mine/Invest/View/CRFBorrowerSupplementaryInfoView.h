//
//  CRFBorrowerSupplementaryInfoView.h
//  crf_purse
//
//  Created by mystarains on 2018/11/28.
//  Copyright © 2018 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFBorrowerInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRFBorrowerSupplementaryInfoView : UIView


- (void)setContentWithBorrowerInfoModel:(CRFBorrowerInfoModel*)borrowerInfoModel;
- (void)showAlert;

@end

NS_ASSUME_NONNULL_END
