//
//  NSString+Help.m
//  jyy
//
//  Created by bob on 2/20/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "NSString+Help.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Help)
- (NSString *)trimString
{
    if (!self) {
        return self;
    }
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
    NSString *strRet = [[self componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString:@""];
    strRet = [strRet stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return strRet;
}

- (NSString *)getNetUrl
{
    NSString *strUrl = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return strUrl;
}

- (UIColor *)getColorFromString
{
    float fR = [[[self componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
    float fG = [[[self componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
    float fB = [[[self componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
    float fA = [[[self componentsSeparatedByString:@","] objectAtIndex:3] floatValue];
    //float fA = 1.0;
    UIColor *color = [UIColor colorWithRed:fR green:fG blue:fB alpha:fA];
    return color;
}


- (NSString *)getNumFromDate // 格式为2012-12-02
{
    NSArray *array = [self componentsSeparatedByString:@"-"];
    if (!array || array.count != 3)
        return nil;
    NSString *strReturn = [NSString stringWithFormat:@"%@%@%@", [array objectAtIndex:0], [array objectAtIndex:1], [array objectAtIndex:2]];
    return strReturn;
}
- (NSString *)getNUmFromTime //格式为 12:21
{
    NSArray *array = [self componentsSeparatedByString:@":"];
    if (!array || array.count != 2)
        return nil;
    NSString *strReturn = [NSString stringWithFormat:@"%@%@", [array objectAtIndex:0], [array objectAtIndex:1]];
    return strReturn;
}

- (NSString *)getDate
{
    if([self length] != 8)
        return nil;
    NSRange range = NSMakeRange(4, 2);
    NSString *strReturn = [NSString stringWithFormat:@"%@-%@-%@", [self substringToIndex:4], [self substringWithRange:range], [self substringFromIndex:6]];
    return strReturn;
}
- (NSString *)getTime
{
    if([self length] != 4)
        return nil;
    NSString *strReturn = [NSString stringWithFormat:@"%@:%@", [self substringToIndex:2], [self substringFromIndex:2]];
    return strReturn;
}


+ (NSString *)keyForFilePath:(NSString *)strFilePath
{
    if(ISEMPTY(strFilePath))
    {
        return nil;
    }
    //    NSString *urlString = [url absoluteString];
    //    if ([urlString length] == 0) {
    //        return nil;
    //    }
    //
    //    // Strip trailing slashes so http://allseeing-i.com/ASIHTTPRequest/ is cached the same as http://allseeing-i.com/ASIHTTPRequest
    //    if ([[urlString substringFromIndex:[urlString length]-1] isEqualToString:@"/"]) {
    //        urlString = [urlString substringToIndex:[urlString length]-1];
    //    }
    
    // Borrowed from: http://stackoverflow.com/questions/652300/using-md5-hash-on-a-string-in-cocoa
    const char *cStr = [strFilePath UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}
@end
