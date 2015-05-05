//
//  UIImage+Extensions.h
//  Zine
//
//  Created by bob on 13-9-13.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
- (UIImage *)clipImageFromTop:(CGSize)asize;
- (UIImage *)clipImageToScaleSize:(CGSize)asize;
- (UIImage *)clipImageToScaleSizeWithFixedScale:(CGSize)asize;
- (UIImage *)clipImageToScaleSizeFromTop:(CGSize)asize;
@end
