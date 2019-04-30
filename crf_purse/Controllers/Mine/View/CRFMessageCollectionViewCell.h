//
//  CRFMessageCollectionViewCell.h
//  crf_purse
//
//  Created by xu_cheng on 2017/10/18.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, MessageType) {
    TypeOfMessage          = 0,
    TypeOfNotice           = 1
};

@interface CRFMessageCollectionViewCell : UICollectionViewCell

/**
 消息类型
 */
@property (nonatomic, assign) MessageType type;

/**
 获取未读消息个数
 */
@property (nonatomic, copy) void (^(getUnRedMessageCount))(NSInteger count);
@property (nonatomic, copy) void (^(setEditBtn))(BOOL isEdit);
/**
 查看详情
 */
@property (nonatomic, copy) void (^ (pushToMessageDetailHandler))(id selectedObject,MessageType type);

@property (nonatomic , assign) BOOL isEditStatus;

@end
