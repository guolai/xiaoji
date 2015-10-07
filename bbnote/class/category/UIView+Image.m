//
//  UIView+Image.m
//  Zine
//
//  Created by bob on 9/18/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import "UIView+Image.h"

@implementation UIView (Image)
- (UIImage *)translateToImage
{
    CGFloat scale = 1.0;
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    }
    
    if(scale > 1.0) {
        CGSize size = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(self.bounds.size);
    }

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fullimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return fullimage;
}

- (UIImage *)translateToImageInRect:(CGRect)rect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    }
    
    if(scale > 1.0) {
        CGSize size = CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.bounds.size);
    }

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fullimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect cropRect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale,  rect.size.width * scale, rect.size.height * scale);
    CGImageRef imageRef=CGImageCreateWithImageInRect(fullimage.CGImage, cropRect);
    UIImage* partImage =[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return partImage;
}

@end

@implementation UIScrollView(scrview)

- (UIImage *)translateToImage
{
    CGFloat scale = 1.0;
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    }
    
    if(scale > 1.0) {
        CGSize size = CGSizeMake(self.contentSize.width * scale, self.contentSize.height * scale);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.contentSize);
    }
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fullimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return fullimage;
}


@end
