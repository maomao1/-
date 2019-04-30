//
//  CRFVersionInfo.h
//  CashLoan
//
//  Created by crf on 15/10/19.
//  Copyright © 2015年 crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFVersionInfo : NSObject <NSCoding>{
    NSString *versionCode;
    NSString *updateTime;
    NSString *appLink;
    NSString *appTips;
    NSString *level;
}
@property (strong,nonatomic) NSString *versionCode;//版本号
@property (strong,nonatomic) NSString *updateTime;//
@property (strong,nonatomic) NSString *appLink;//
@property (strong,nonatomic) NSString *appTips;//
@property (strong,nonatomic) NSString *level;//0普通,  1强制
@end
