//
//  CRFHomeBottomView.h
//  crf_purse
//
//  Created by mystarains on 2019/1/10.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRFHomeBottomView : UIView

@property (nonatomic, copy) NSDictionary *homeHeaderViewDic;

@property (nonatomic,copy) void(^showInformationBlock)(CRFAppHomeModel *model);

@end

NS_ASSUME_NONNULL_END
