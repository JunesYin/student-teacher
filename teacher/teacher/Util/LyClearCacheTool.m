//
//  LyClearCacheTool.m
//  teacher
//
//  Created by Junes on 09/10/2016.
//  Copyright © 2016 517xueche. All rights reserved.
//

#import "LyClearCacheTool.h"



@implementation LyClearCacheTool


+ (NSString *)cacheSize:(NSArray *)arrPath {
    
    if (!arrPath || arrPath.count < 1) {
        arrPath = @[
                    //Document
                    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject],
                    //Library
                    [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject],
                    //Library/Caches
                    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject],
                    //Library/Preferences
                    [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/Preferences"]
                    ];
    }
    
    NSString *filePath = nil;
    NSInteger iTotalSize = 0;
    NSError *error = nil;
    
    for (NSString *path in arrPath) {
        //获取应用文件夹下面的所有文件
        NSArray *arrSubPath = [[NSFileManager defaultManager] subpathsAtPath:path];
        
        if (!arrSubPath || arrSubPath.count < 1) {
            continue;
        }
        
        for (NSString *subPath in arrSubPath) {
            
            //拼接每一个文件的全路径
            filePath = [path stringByAppendingFormat:@"/%@", subPath];
            
            
            //是否是文件夹
            BOOL isDirectory = NO;
            
            //是否存在
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
            
            //只计算存在的、不为文件夹的、不为隐藏文件的文件
            if (!isExist || isDirectory || [filePath containsString:@".DS"]) {
                continue;
            }
            
            //获取文件大小
            error = nil;
            NSDictionary *dic=   [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
            if (!error) {
                NSInteger size=[[dic objectForKey:@"NSFileSize"] integerValue];
                iTotalSize += size;
            }
        }

    }
    
    
    NSString *cacheSize = nil;
    //转化为相应格式
    if (iTotalSize < 1024) {
        cacheSize = [[NSString alloc] initWithFormat:@"%.1fB", iTotalSize / 1.0f];
    } else if (iTotalSize < 1014 * 1024) {
        cacheSize = [[NSString alloc] initWithFormat:@"%.1fKB", iTotalSize / 1024.0f];
    } else {
        cacheSize = [[NSString alloc] initWithFormat:@"%.1fM", iTotalSize / 1024.0f / 1024.0f];
    }
    
    return cacheSize;
}


+ (BOOL)clearCache:(NSArray *)arrPath {
    
//    if (!path) {
//        path = appFilePath;
//    }
//    
//    //获取应用文件夹下面的所有文件
//    NSArray *arrSubPath = [[NSFileManager defaultManager] subpathsAtPath:path];
//    
//    if (!arrSubPath || arrSubPath.count < 1) {
//        return YES;
//    }
//    
//    NSError *error = nil;
//    NSString *filePath = nil;
//    
//    for (NSString *subPath in arrSubPath) {
//        //拼接每一个文件的全路径
//        filePath = [appFilePath stringByAppendingString:subPath];
//        
//        //删除
//        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//        if (!error) {
//            NSLog(@"清除成功：%@", filePath);
//        } else {
//            NSLog(@"清除失败：%@", filePath);
//            return NO;
//        }
//    }
    
    return YES;
}


@end


