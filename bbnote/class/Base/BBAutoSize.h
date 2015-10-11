//
//  BBAutoSize.h
//  bbnotes
//
//  Created by bob on 4/23/15.
//  Copyright (c) 2015 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBAutoSize : NSObject

+(void)reGetScreenSize;

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGFloat)screenScale;
+ (CGSize)screenSize;//当前屏幕
+ (CGRect)screenRect;//当前屏幕

+ (CGFloat)resizeWidth:(CGFloat)fWidth;
+ (CGFloat)resizeHeight:(CGFloat)fHeight;

+ (CGFloat)resizeScrFont:(CGFloat)fFont;
+ (CGFloat)getResizeScale;


@end
