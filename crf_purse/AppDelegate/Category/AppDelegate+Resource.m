//
//  AppDelegate+Resource.m
//  crf_purse
//
//  Created by xu_cheng on 2018/2/2.
//  Copyright © 2018年 com.crfchina. All rights reserved.
//

#import "AppDelegate+Resource.h"
#import "CRFFilePath.h"
#import "SSZipArchive.h"

@implementation AppDelegate (Resource)

- (void)loadResource {
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] get:[NSString stringWithFormat:APIFormat(kGetAppPageConfigPath),@"new_year_theme"] success:^(CRFNetworkCompleteType errorType, id response) {
        CRFAppHomeModel *model = [[CRFResponseFactory handleBannerDataForResult:response ForKey:@"new_year_theme"] firstObject];
        if (!model) {
            return ;
        }
        strongSelf(weakSelf);
        NSString *path = [CRFUserDefaultManager getResourceFlag:model.jumpUrl];
        if (!path) {
            [strongSelf removeResource];
            [strongSelf beginDownTask:model.jumpUrl];
        } else {
            NSLog(@"本地资源文件已存在");
            [CRFAppManager defaultManager].needReloadIcon = YES;
            [CRFAppManager defaultManager].resourcePath = [[strongSelf sourcePath] stringByAppendingPathComponent:path] ;
            [CRFNotificationUtils postNotificationName:kReloadResourceNotificationName object:[CRFAppManager defaultManager].resourcePath];
        }
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        NSLog(@"查询资源文件失败");
    }];
}

- (void)beginDownTask:(NSString *)url {
    if (!url || [url isEmpty]) {
        NSLog(@"暂无下载任务");
        return;
    }
    weakSelf(self);
    [[CRFStandardNetworkManager defaultManager] downLoadTask:url filePath:^NSURL * _Nonnull(NSURL * _Nullable targetPath, NSURLResponse * _Nonnull response) {
        NSString *filePath = [CRFFilePath createFilePath:@"resouceIcon"];
        return  [NSURL fileURLWithPath:[filePath stringByAppendingPathComponent:response.suggestedFilename]];
    } success:^(CRFNetworkCompleteType errorType, NSURL *response) {
        NSString *htmlFilePath = [response path];// 将NSURL转成NSString
        strongSelf(weakSelf);
        [strongSelf releaseZipFilesWithUnzipFileAtPath:htmlFilePath destination:[strongSelf sourcePath] sourceUrl:url];
    } failed:^(CRFNetworkCompleteType errorType, id response) {
        NSLog(@"下载任务失败");
    }];
}

- (void)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath destination:(NSString *)unzipPath sourceUrl:(NSString *)sourceUrl {
   BOOL result = [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
       NSLog(@"解压进度为%.2f, 信息为%@",(entryNumber * 1.00/ total),entry);
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
             NSLog(@"解压资源zip文件完成，资源文件路径为：%@",path);
        } else {
            NSLog(@"解压资源zip文件失败，错误原因：%@",error);
        }
    }];
    if (result) {
        NSLog(@"success   path is %@",unzipPath);
        NSString *desPath = [self formatPath:unzipPath];
        if (desPath) {
            [CRFAppManager defaultManager].needReloadIcon = YES;
            [CRFAppManager defaultManager].resourcePath = desPath;
            [CRFNotificationUtils postNotificationName:kReloadResourceNotificationName object:desPath];
            [CRFUserDefaultManager setResourceFlag:[[desPath componentsSeparatedByString:@"/"] lastObject]  key:sourceUrl];
        } else {
            NSLog(@"解压后的文件不存在");
        }
    } else {
        NSLog(@"解压失败");
    }
}

- (NSString *)formatPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            NSArray *dirList = [fileManager contentsOfDirectoryAtPath:path error:nil];
            for (NSString *str in dirList) {
                NSString *sub = [path stringByAppendingPathComponent:str];
                BOOL desDir = NO;
                [fileManager fileExistsAtPath:sub isDirectory:&desDir];
                if (desDir) {
                    return sub;
                }
            }
            return nil;
        } else {
            return nil;
        }
    }
    return nil;
}

- (void)removeResource {
    NSString *documentsPath = [self sourcePath];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsPath];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[documentsPath stringByAppendingPathComponent:fileName] error:nil];
    }
}

- (NSString *)sourcePath {
#if TARGET_IPHONE_SIMULATOR  //模拟器
    NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
#elif TARGET_OS_IPHONE      //真机
    NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
#endif
    NSString *path = [[documentArray lastObject] stringByAppendingPathComponent:@"Preferences"];
    return path;
}

@end
