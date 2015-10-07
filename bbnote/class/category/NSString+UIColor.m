//
//  NSString+UIColor.m
//  bbnote
//
//  Created by zhuhb on 13-6-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "NSString+UIColor.h"

@implementation NSString (UIColor)

- (UIColor *)getColorFromString
{
    UIColor *color = nil;
    if([self componentsSeparatedByString:@","].count == 4)
    {
        int iR = [[[self componentsSeparatedByString:@","] objectAtIndex:0] intValue];
        int iG = [[[self componentsSeparatedByString:@","] objectAtIndex:1] intValue];
        int iB = [[[self componentsSeparatedByString:@","] objectAtIndex:2] intValue];
        int iA = [[[self componentsSeparatedByString:@","] objectAtIndex:3] intValue];
        color = [UIColor colorWithRed:iR/255.0 green:iG/255.0 blue:iB/255.0 alpha:iA/255.0];
    }
    else
    {
        NSAssert(false, @"error color");
    }

    return color;
}

- (UIColor *)getColorFromRGBBlendR:(NSUInteger)nR G:(NSUInteger)nG B:(NSUInteger)nB alpha:(CGFloat)fA
{
    if(self.length < 5 || ![self hasPrefix:@"rgb"])
    {
        NSAssert(false, @"error color");
        return [UIColor colorWithRed:10 green:10 blue:10 alpha:1];
    }
    NSString *strColor = [self substringFromIndex:5];
    NSArray *array = [strColor componentsSeparatedByString:@","];
    NSAssert(array.count >= 3, @"rgb color error");
    CGFloat iR = [[array objectAtIndex:0] floatValue];
    CGFloat iG = [[array objectAtIndex:1] floatValue];
    CGFloat iB = [[array objectAtIndex:2] floatValue];
    iR = iR * (1 - fA) + (nR * fA);
    iG = iG  * (1 - fA) + (nG * fA);
    iB = iB  * (1 - fA) + (nB * fA);
//    Vlog(@"%f,%f,%f", iR, iG, iB);
//    iR = iR / fA;
//    iG = iG / fA;
//    iB = iB / fA;
    UIColor * color = [UIColor colorWithRed:iR/255.0 green:iG/255.0 blue:iB/255.0 alpha:1];
    return color;
}


- (UIColor *)getColorFromFromRGB:(CGFloat)fAlpha
{
    if(fAlpha < 0.001)
    {
        fAlpha = 0.1;
    }
    if(fAlpha > 1.0)
    {
        fAlpha = 1.0;
    }
    if(self.length < 5)
    {
        NSAssert(false, @"error color");
        return [UIColor colorWithRed:10 green:10 blue:10 alpha:fAlpha];
    }
 
    NSString *strColor = [self substringFromIndex:5];
    NSArray *array = [strColor componentsSeparatedByString:@","];
    NSAssert(array.count >= 3, @"rgb color error");
    int iR = [[array objectAtIndex:0] intValue];
    int iG = [[array objectAtIndex:1] intValue];
    int iB = [[array objectAtIndex:2] intValue];
    UIColor * color = [UIColor colorWithRed:iR/255.0 green:iG/255.0 blue:iB/255.0 alpha:fAlpha];
    return color;
}

- (UIColor *)getColorFromRGBA //rgba(26,20,20,1.0)
{
    return [self getColorFromFromRGB:1.0];
}

- (UIColor *)getColorFromHexString:(CGFloat)fAlpha
{
    UIColor *color = [UIColor purpleColor];
    int iR = 0, iG = 0, iB = 0;
    if(self.length != 7)
    {
        return color;
    }
    NSString *strValue = [self substringFromIndex:1];
    strValue = [strValue lowercaseString];
    NSData *data = [strValue dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[data bytes];
    if(data.length != 6)
    {
        return color;
    }
    for (int i = 0; i < 6; i++) {
        
        int *iRet = 0;
        if(i < 2)
        {
            iRet = &iR;
        }
        else if(i < 4)
        {
            iRet = &iG;
        }
        else
        {
            iRet = &iB;
        }
        int iResult = 0;
        if(bytes[i] >= '0' && bytes[i] <= '9')
        {
            iResult = bytes[i] - '0';
        }
        else if(bytes[i] >= 'a' && bytes[i] <= 'f')
        {
            iResult = bytes[i] - 'a' + 10;
        }
        if(i%2 == 0)
        {
            *iRet = iResult * 16 + *iRet;
        }
        else
        {
            *iRet = iResult + *iRet;
        }
    }
    //Vlog(@"%d, %d, %d", iR, iG, iB);
    if(fAlpha < 0.001)
    {
        fAlpha = 0.1;
    }
    if(fAlpha > 1.0)
    {
        fAlpha = 1.0;
    }
    color = [UIColor colorWithRed:iR/255.0 green:iG/255.0 blue:iB/255.0 alpha:fAlpha];
    return color;
}

- (UIColor *)getColorFromHexString
{
    return [self getColorFromHexString:1.0];
}

- (NSString *)getStringColorFromRGBA
{
    if(self.length < 5)
    {
        NSAssert(false, @"error");
        return @"255,255,255,255";
    }
    NSString *strColor = [self substringFromIndex:5];
    NSArray *array = [strColor componentsSeparatedByString:@","];
    NSAssert(array.count == 4, @"rgb color error");
    int iR = [[array objectAtIndex:0] intValue];
    int iG = [[array objectAtIndex:1] intValue];
    int iB = [[array objectAtIndex:2] intValue];
    return [NSString stringWithFormat:@"%d,%d,%d,255", iR, iG, iB];
}

- (UIColor *)getColorFromCSSString
{
    int r,g,b;
    r = g = b = 0;
    NSString *lowerStr = [NSString stringWithString:[self lowercaseString]];
    
    if ([lowerStr hasPrefix:@"#"]) {
        NSUInteger length = lowerStr.length;
        if (7 != length && 9 != length) {
           NSAssert(false, @"error");
            return [UIColor blackColor];
        }
        
        int intA = 0;
        NSString *hexStr = [lowerStr substringFromIndex:1];
        length = hexStr.length;
        if (6 == length) {
            intA = 255;
        }
        NSData *data = [hexStr dataUsingEncoding:NSUTF8StringEncoding];
        Byte *bytes = (Byte *)[data bytes];
        
        for (int i = 0; i < length; ++i) {
            int *intP = NULL;
            if (i < 2) {
                intP = &r;
            } else if (i < 4) {
                intP = &g;
            } else if (i < 6) {
                intP = &b;
            } else {
                intP = &intA;
            }
            
            int intC = 0;
            if (bytes[i] >= '0' && bytes[i] <= '9') {
                intC = bytes[i]-'0';
            } else if (bytes[i] >= 'a' && bytes[i] <= 'f') {
                intC = bytes[i]-'a'+10;
            }
            
            if (0 == i%2) {
                *intP = intC*16;
            } else {
                *intP = *intP+intC;
            }
        }
        
        return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:intA/255.0];
        
    } else if ([lowerStr hasPrefix:@"rgb("]) {
        NSString *rgbStr = [lowerStr substringWithRange:NSMakeRange(4, lowerStr.length-5)];
        rgbStr = [rgbStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *ary = [rgbStr componentsSeparatedByString:@","];
        if (3 != ary.count) {
            return nil;
        }
        
        r = [[ary objectAtIndex:0] intValue];
        g = [[ary objectAtIndex:1] intValue];
        b = [[ary objectAtIndex:2] intValue];
        
        return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        
    } else if ([lowerStr hasPrefix:@"rgba("]) {
        NSString *rgbStr = [lowerStr substringWithRange:NSMakeRange(5, lowerStr.length-6)];
        rgbStr = [rgbStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *ary = [rgbStr componentsSeparatedByString:@","];
        if (4 != ary.count) {
            return nil;
        }
        
        r = [[ary objectAtIndex:0] intValue];
        g = [[ary objectAtIndex:1] intValue];
        b = [[ary objectAtIndex:2] intValue];
        float floatA = [[ary objectAtIndex:3] floatValue];
        return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:floatA];
        
    }
    
    return nil;
}

@end
