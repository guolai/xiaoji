//
//  NSString+UIColor.h
//  bbnote
//
//  Created by zhuhb on 13-6-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UIColor)
- (UIColor *)getColorFromString;
- (UIColor *)getColorFromRGBBlendR:(NSUInteger)nR G:(NSUInteger)nG B:(NSUInteger)nB alpha:(CGFloat)fA;
- (UIColor *)getColorFromFromRGB:(CGFloat)fAlpha;
- (UIColor *)getColorFromRGBA;

- (UIColor *)getColorFromHexString:(CGFloat)fAlpha;
- (UIColor *)getColorFromHexString;
- (NSString *)getStringColorFromRGBA;
- (UIColor *)getColorFromCSSString;
@end
