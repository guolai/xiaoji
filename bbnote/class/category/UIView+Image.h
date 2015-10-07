//
//  UIView+Image.h
//  Zine
//
//  Created by bob on 9/18/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Image2)
- (UIImage *)translateToImage;
- (UIImage *)translateToImageInRect:(CGRect)rct;
@end

@interface UIScrollView(scrview)
- (UIImage *)translateToImage;
@end
