//
//  ImageCacheManager.h
//  bbnotes
//
//  Created by bob on 4/28/15.
//  Copyright (c) 2015 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCacheManager : NSObject
{
    NSMutableDictionary *_cacheImageDic;
}

+ (ImageCacheManager *)shareInstance;

- (void)saveImageToCache:(UIImage *)image filePath:(NSString *)strPath;
- (UIImage *)getCachedImageFromFilePath:(NSString *)strPath;

- (void)clearCache;

@end
