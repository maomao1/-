//
//  CRFAppointmentForwardTableViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2018/3/19.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRFAppointmentForwardTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *iconNamed;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray <NSString *> *eventNames;

@property (nonatomic, strong) NSArray <NSAttributedString *> * attributedEventNames;

@property (nonatomic, copy) void (^(explainHandler))(void);

@property (nonatomic, assign) BOOL itemDisable;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) NSInteger selectedItem;

@property (nonatomic, copy) void (^(itemDidSelectedHandler))(NSIndexPath *indexPath, NSInteger item, BOOL selected);

@end
