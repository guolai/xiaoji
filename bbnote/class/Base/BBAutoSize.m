//
//  BBAutoSize.m
//  bbnotes
//
//  Created by bob on 4/23/15.
//  Copyright (c) 2015 bob. All rights reserved.
//

#import "BBAutoSize.h"



static CGFloat _scrWidth;
static CGFloat _scrHeight;

@implementation BBAutoSize


+(void)reGetScreenSize
{
    _scrWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    _scrHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
}

+ (CGFloat)screenWidth
{
    return _scrWidth;
}

+ (CGFloat)screenHeight
{
    return _scrHeight;
}

+ (CGSize)screenSize//当前屏幕
{
    return CGSizeMake(_scrWidth, _scrHeight);
}

+ (CGRect)screenRect//当前屏幕
{
    return CGRectMake(0, 0, _scrWidth, _scrHeight);
}

+ (CGFloat)resizeWidth:(CGFloat)fWidth
{
    if(isIphone3Dot5)
    {
        return fWidth;
    }
    return (CGFloat)((fWidth * _scrWidth) / 320);
}


+ (CGFloat)resizeHeight:(CGFloat)fHeight
{
    if(isIphone3Dot5)
    {
        return fHeight;
    }
    return (CGFloat)((fHeight * _scrWidth) / 568);
}

+ (CGFloat)resizeScrFont:(CGFloat)fFont
{
    if(isIphone3Dot5)
    {
        return fFont;
    }
    CGFloat fScale = _scrWidth / 320;
    fFont = fScale * fFont;
    return fFont;
}

+ (CGFloat)getResizeScale
{
    if(isIphone3Dot5)
    {
        return 1.0f;
    }
    CGFloat fScale = _scrWidth / 320;
    if(fScale < 1.0f)
    {
        NSAssert(false, @"get a null screen size");
        fScale = 1.0f;
    }
    
    return fScale;
}

@end
