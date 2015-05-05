//
//  UIImage+SCaleImage.h
//  ibabycloud
//
//  Created by zhuhb on 13-1-21.
//  Copyright (c) 2013年 ibabylabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define degreesToRadians(x) (M_PI * (x) / 180.0)

@interface UIImage (SCaleImage)
-(UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)scaleImageToScale:(float)scaleSize;
- (UIImage *)imageAutoScale;
- (UIImage*)imageWithCircularMask;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)clipImageToScaleSize:(CGSize)asize;
-(UIImage*)rotateImage:(UIImageOrientation)orient;

@end
