//
//  CRFVersionModel.h
//  crf_purse
//
//  Created by maomao on 2017/8/10.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CRFVersionContentModel;
@interface CRFVersionContentModel:NSObject
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *content;
@end
@interface CRFVersionModel : NSObject
@property (nonatomic , copy) NSString *versionName;
@property (nonatomic ,strong)NSArray  *versionContent;
@end
