//
//  CRFInvestHead.h
//  crf_purse
//
//  Created by maomao on 2017/11/8.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRFLabel.h"
@protocol CRFInvestHeadCellDelegate <NSObject>

-(void)crfSelectedIndex:(NSInteger)index;

@end
#define SelectedColor   UIColorFromRGBValue(0xFB4D3A)
#define KHeadViewHeight   54
@class CRFInvestHeadCell;
@interface CRFInvestHead : UIView
@property (nonatomic , strong) NSArray *titles;
@property (nonatomic , weak) id<CRFInvestHeadCellDelegate> delegate;
@end
@interface CRFInvestHeadCell : UICollectionViewCell
@property (nonatomic ,strong) CRFLabel *mainTitle;
@property (nonatomic ,strong) CRFLabel *subTitle;
-(void)crfSetcontent:(NSString*)title andSubtitle:(NSString*)subtitle IsSelected:(BOOL)isSelected;
-(void)crfSetSelected:(BOOL)isSelected;
@end
