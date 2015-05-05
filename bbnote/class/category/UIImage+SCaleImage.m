//
//  UIImage+SCaleImage.m
//  ibabycloud
//
//  Created by zhuhb on 13-1-21.
//  Copyright (c) 2013年 ibabylabs. All rights reserved.
//

#import "UIImage+SCaleImage.h"

@implementation UIImage (SCaleImage)
- (UIImage *)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)scaleImageToScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*scaleSize, self.size.height*scaleSize));
    [self drawInRect:CGRectMake(0.0, 0.0, self.size.width * scaleSize, self.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}

- (UIImage *)clipImageToScaleSize:(CGSize)asize
{
    if (!self) {
        return nil;
    }
    CGSize oldsize = self.size;
    CGRect rect;
    if (asize.width/asize.height > oldsize.width/oldsize.height) {
        rect.size.width = asize.width;
        rect.size.height = asize.width*oldsize.height/oldsize.width;
        rect.origin.x = 0;
        rect.origin.y = (asize.height - rect.size.height)/2;
    } else{
        rect.size.width = asize.height*oldsize.width/oldsize.height;
        rect.size.height = asize.height;
        rect.origin.x = (asize.width - rect.size.width)/2;
        rect.origin.y = 0;
    }
    
    UIGraphicsBeginImageContextWithOptions(asize, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, CGRectMake(0, 0, asize.width, asize.height));
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
    [self drawInRect:rect];
    UIImage* newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}

- (UIImage *)imageAutoScale //保证宽为320
{
//    float fScale = 1.0;
//    float fMax = self.size.width;
//    if(self.size.width < self.size.height)
//    {
//        fMax = self.size.height;
//    }
//    CGFloat scale = 1.0;
//    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)])
//    {
//        CGFloat tmp = [[UIScreen mainScreen] scale];
//        if (tmp > 1.5)
//        {
//            scale = 2.0;
//        }
//    }
////    fMax /= scale;
//    if(fMax > 320)
//    {
//        fScale = 320 / fMax;
//    }
//    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*fScale, self.size.height*fScale));
//    [self drawInRect:CGRectMake(0, 0, self.size.width * fScale, self.size.height *fScale)];
//    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return scaledImage;

    return [self clipImageToScaleSize:CGSizeMake(320, 240)];
    CGSize size = CGSizeMake(320.0 , self.size.height * 320.0  / self.size.width);
    return [self resizedImage:size interpolationQuality:kCGInterpolationDefault];
}


- (UIImage*)imageWithCircularMask {
    CGContextRef context = CGBitmapContextCreate(NULL, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    CGRect imageRect = (CGRect){CGPointZero, self.size};
    
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, imageRect);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, imageRect, self.CGImage);
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:clippedImage];
    
    CGImageRelease(clippedImage);
    CGContextRelease(context);
    
    return maskedImage;
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio;
    CGFloat verticalRatio;
    CGFloat ratio;
    CGSize  newSize;
    
    BOOL hasRetina = ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0));
    if (hasRetina) {
        bounds.width  = ceil(bounds.width  * 2);
        bounds.height = ceil(bounds.height * 2);
    }
    
    switch (contentMode) {
        case UIViewContentModeScaleToFill:
            horizontalRatio = self.size.width  / bounds.width;
            verticalRatio   = self.size.height / bounds.height;
            break;
            
        default:
            horizontalRatio = bounds.width  / self.size.width;
            verticalRatio   = bounds.height / self.size.height;
            break;
    }
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleToFill:
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", contentMode];
    }
    
    switch (contentMode) {
        case UIViewContentModeScaleToFill:
            newSize = CGSizeMake(bounds.width * ratio, bounds.height * ratio);
            break;
        default:
            newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
            break;
    }
    
    return [self resizedImage:newSize interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}


-(UIImage*)rotateImage:(UIImageOrientation)orient
{
	CGRect			bnds = CGRectZero;
	UIImage*		   copy = nil;
	CGContextRef	  ctxt = nil;
	CGRect			rect = CGRectZero;
	CGAffineTransform  tran = CGAffineTransformIdentity;
	bnds.size = self.size;
	rect.size = self.size;
	//CLog("%s, %d", __FUNCTION__, orient);
	switch (orient)
	{
		case UIImageOrientationUp:
			return self;
		case UIImageOrientationUpMirrored:
			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			break;
		case UIImageOrientationDown:
			tran = CGAffineTransformMakeTranslation(rect.size.width,
													rect.size.height);
			tran = CGAffineTransformRotate(tran, degreesToRadians(180.0));
			break;
		case UIImageOrientationDownMirrored:
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
			tran = CGAffineTransformScale(tran, 1.0, -1.0);
			break;
		case UIImageOrientationLeft: {
			//CGFloat wd = bnds.size.width;
            //			bnds.size.width = bnds.size.height;
            //			bnds.size.height = wd;
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
			tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
		}
			break;
		case UIImageOrientationLeftMirrored: {
			//CGFloat wd = bnds.size.width;
            //			bnds.size.width = bnds.size.height;
            //			bnds.size.height = wd;
			tran = CGAffineTransformMakeTranslation(rect.size.height,
													rect.size.width);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
		}
			break;
		case UIImageOrientationRight: {
			CGFloat wd = bnds.size.width;
			bnds.size.width = bnds.size.height;
			bnds.size.height = wd;
			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
		}
			break;
		case UIImageOrientationRightMirrored: {
			//CGFloat wd = bnds.size.width;
            //			bnds.size.width = bnds.size.height;
            //			bnds.size.height = wd;
			tran = CGAffineTransformMakeScale(-1.0, 1.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
		}
			break;
		default:
			// orientation value supplied is invalid
			assert(false);
			return nil;
	}
	UIGraphicsBeginImageContext(rect.size);
	ctxt = UIGraphicsGetCurrentContext();
	switch (orient)
	{
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			CGContextScaleCTM(ctxt, -1.0 * (rect.size.width / rect.size.height), 1.0 * (rect.size.height / rect.size.width));
			CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
			break;
		default:
			CGContextScaleCTM(ctxt, 1.0, -1.0);
			CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
			break;
	}
	CGContextConcatCTM(ctxt, tran);
	CGContextDrawImage(ctxt, rect, self.CGImage);
	copy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return copy;
}
@end
