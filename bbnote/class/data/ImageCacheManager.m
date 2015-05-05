//
//  ImageCacheManager.m
//  bbnotes
//
//  Created by bob on 4/28/15.
//  Copyright (c) 2015 bob. All rights reserved.
//

#import "ImageCacheManager.h"
#import "NSString+Help.h"

static ImageCacheManager *_imageCacheManager;
@implementation ImageCacheManager


+ (ImageCacheManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageCacheManager = [[ImageCacheManager alloc] init];
    });
    return _imageCacheManager;
}

- (instancetype)init
{
    if(self = [super init])
    {
        _cacheImageDic = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
    return self;
}

- (void)saveImageToCache:(UIImage *)image filePath:(NSString *)strPath
{
    NSString *strKey = [NSString keyForFilePath:strPath];
    if(strKey && image)
    {
        @synchronized(_cacheImageDic)
        {
            [_cacheImageDic setObject:image forKey:strKey];
        }
    }
}

- (UIImage *)getCachedImageFromFilePath:(NSString *)strPath
{
    UIImage *image = nil;
    NSString *strKey = [NSString keyForFilePath:strPath];
    if(strKey)
    {
        @synchronized(_cacheImageDic)
        {
            image = [_cacheImageDic objectForKey:strKey];
        }
    }
    return image;
}

- (void)clearCache
{
    @synchronized(_cacheImageDic)
    {
        [_cacheImageDic removeAllObjects];
    }
}

@end
