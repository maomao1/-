//
//  CRFHomeNavView.h
//  crf_purse
//
//  Created by mystarains on 2019/1/9.
//  Copyright © 2019 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum MessageIconType{
    MessageIconTypeWhiteNoMessage,
    MessageIconTypeWhiteMessage,
    MessageIconTypeGrayNoMessage,
    MessageIconTypeGrayMessage
}MessageIconTypes;

@interface CRFHomeNavView : UIView

@property (nonatomic, copy) NSString *messageCount;

- (void)changeViewAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
