//
//  CRFMessageScrollVC.h
//  crf_purse
//
//  Created by maomao on 2017/8/2.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFBasicViewController.h"
typedef void (^refreshMineUnreadBlock)();


@interface CRFMessageScrollViewController : CRFBasicViewController

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic , copy) refreshMineUnreadBlock refreshUnReadBlock;
@end
