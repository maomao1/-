//
//  CRFMineTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/7/4.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const CRFMineTableViewCellId = @"CRFMineTableViewCellIdentifer";
static NSString *const CRFMineTableBgCellId   = @"CRFMineTableBgCellId";
typedef NS_ENUM(NSUInteger, NewMessageStyle) {
    None                = 0,
    Number              = 1,
    String              = 2,
};
@protocol CRFMineTableViewCellDelegate <NSObject>
- (void)crfSelectedMineIndex:(NSInteger)index;
@end

@interface CRFMineTableViewCell : UITableViewCell
@property (nonatomic ,strong) UICollectionView *mainCollectionView;

@property (nonatomic, assign) NSUInteger badgeNumber;

@property (nonatomic, assign) NewMessageStyle messageStyle;
@property (nonatomic, weak) id<CRFMineTableViewCellDelegate>delegate;

@property  (nonatomic , strong) NSArray  * titles;
@property  (nonatomic , strong) NSArray  * images;
@property  (nonatomic , strong) NSArray  * secondTitles;

@end
