//
//  BBAssetWrapper.h
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;
@interface BBAssetWrapper : NSObject

@property (nonatomic, strong, readonly) ALAsset *asset;

+ (BBAssetWrapper *)wrapperWithAsset:(ALAsset *)asset;

- (id)initWithAsset:(ALAsset *)asset;
@end
