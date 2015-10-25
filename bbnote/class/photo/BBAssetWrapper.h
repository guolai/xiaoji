//
//  BBAssetWrapper.h
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;

typedef NS_ENUM(NSUInteger, PaperType) {
    Paper_Picture,
    Paper_Color,
    Paper_Max
};


@interface PaperItem : NSObject
@property (nonatomic, assign) PaperType paperType;
@property (nonatomic, strong) NSString *strName;

@end


@interface BBAssetWrapper : NSObject

@property (nonatomic, strong, readonly) ALAsset *asset;
@property (nonatomic, strong, readonly) PaperItem *paper;

+ (BBAssetWrapper *)wrapperWithAsset:(ALAsset *)asset;

- (instancetype)initWithAsset:(ALAsset *)asset;
- (instancetype)initWithPhotoItem:(PaperItem *)item;
@end
