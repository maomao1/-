//
//  CRFPhotoUnit.h
//  crf_purse
//
//  Created by maomao on 2018/7/30.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFPhotoUnit : NSObject
+(void)getAuthPhoto;
+(void)saveImage:(NSString*)imageUrl;
@end
