//
//  CRFPhotoUnit.m
//  crf_purse
//
//  Created by maomao on 2018/7/30.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "CRFPhotoUnit.h"
#import <Photos/Photos.h>
@implementation CRFPhotoUnit
+(void)getAuthPhoto{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        DLog(@"用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关");
    }else if (status == PHAuthorizationStatusRestricted){
        DLog(@"家长控制,不允许访问");
    }else if (status == PHAuthorizationStatusNotDetermined){
        DLog(@"用户还没有做出选择");
        
    }else if (status == PHAuthorizationStatusAuthorized){
        DLog(@"用户允许当前应用访问相册");
        
    }
}
+(void)saveImage:(NSString*)imageUrl{
    NSURL *url = [NSURL URLWithString: imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img;
    img = [UIImage imageWithData:data];
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//   __block BOOL isImgCache;
//    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
//        isImgCache = isInCache;
//    }];
//    UIImage *img;
//    if (isImgCache) {
//        img = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
//    } else {
//        //从网络下载图片
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        img = [UIImage imageWithData:data];
//    }
    UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
   
}
+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != NULL) {
        [CRFUtils showMessage:@"图片保存失败" drution:1.0];
    }else{
        [CRFUtils showMessage:@"图片保存成功" drution:1.0];
    }
}
@end
