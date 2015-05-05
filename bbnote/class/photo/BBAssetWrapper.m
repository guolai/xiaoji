//
//  BBAssetWrapper.m
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBAssetWrapper.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation BBAssetWrapper
@synthesize asset = _asset;



+(BBAssetWrapper *)wrapperWithAsset:(ALAsset *)asset
{
    BBAssetWrapper *wrapper = [[BBAssetWrapper alloc] initWithAsset:asset];
    return wrapper;
}

- (id)initWithAsset:(ALAsset *)asset;
{
    if(self = [super init])
    {
        _asset = asset;
    }
    return self;
}

@end