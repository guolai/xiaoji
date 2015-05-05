//
//  NSString+UUID.m
//  Zine
//
//  Created by bob on 13-9-13.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import "NSString+UUID.h"


@implementation NSString (UUID)
+(NSString *)generateKey{
    CFUUIDRef identifier = CFUUIDCreate(NULL);
    
    NSString* identifierString = (NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, identifier));
    CFRelease(identifier);
    NSString *str2=[identifierString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *str3=[str2 lowercaseString];
    //Vlog(@"%@", str3);
    return str3;
}

- (BOOL)isValidateEmail
{
    if (!self) {
        return NO;
    }
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidatePassword
{
    NSString * regex = @"^[A-Za-z0-9][A-Za-z0-9*.+-_]{5,15}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (NSArray *)searchModelImgDivFromContent
{
//    NSString *strRangeImage = @"<img class=\"[a-zA-Z]{3,20}\" src=\"[0-9a-zA-Z-]{5,32}.(jpg|png)\" width=\"[0-9]{1,5}\" height=\"[0-9]{1,5}\">";
//    //    NSString *strRangeImage = @"<img*class=\"[a-zA-Z]{3,20}\"*src=\"[0-9a-z]{32}sml.jpg\"*width=\"[0-9]{1,5}\"*height=\"[0-9]{1,5}\">";
//    NSArray *arry = [self componentsMatchedByRegex:strRangeImage];
//    return arry;
    return [self searchServerImgDivFromContent];
}

- (NSArray *)searchLocaImgDivFromContent
{

//    NSString *strRangeImage = @"<img class=\"[a-zA-Z]{3,20}\" src=\"[0-9a-z]{32}sml.(jpg|png)\" width=\"[0-9]{1,5}\" height=\"[0-9]{1,5}\">";
////    NSString *strRangeImage = @"<img*class=\"[a-zA-Z]{3,20}\"*src=\"[0-9a-z]{32}sml.jpg\"*width=\"[0-9]{1,5}\"*height=\"[0-9]{1,5}\">";
//    NSArray *arry = [self componentsMatchedByRegex:strRangeImage];
//    return arry;
    return [self searchServerImgDivFromContent];
}

- (NSArray *)searchServerImgDivFromContent
{
//    NSString *strRangeImage = @"<img class=\"[a-zA-Z]{3,20}\" src=\"(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|].(jpg|png)\" width=\"[0-9]{1,5}\" height=\"[0-9]{1,5}\">";
//    NSString *strRangeImage = @"<img[^>]*class=\"[a-zA-Z]{3,20}\" src=\"(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|].(jpg|png)\" width=\"[0-9]{1,5}\" height=\"[0-9]{1,5}\">";
//    NSArray *arry = [self componentsMatchedByRegex:strRangeImage];
    
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:2];
    NSArray *matchs = [self searchImgDivRangeFromContent];
    NSInteger rangeOffset = 0;
//    Vlog(@"--%@", self);
    for (NSTextCheckingResult *match in matchs) {
        NSRange imgRange = NSMakeRange([match rangeAtIndex:0].location + rangeOffset, [match rangeAtIndex:0].length);
//        NSRange srcRange = NSMakeRange([match rangeAtIndex:1].location + rangeOffset, [match rangeAtIndex:1].length);
//        NSString* strsrc = [self substringWithRange:srcRange];
        NSString* strimg = [self substringWithRange:imgRange];
//        Vlog(@"----%@", strsrc);
//        Vlog(@"----%@", strimg);
        [retArray addObject:strimg];
    }
    return retArray;
}

- (NSArray *)searchImgDivRangeFromContent
{
    static dispatch_once_t onceToken;
    static NSRegularExpression *imgRegex;
    dispatch_once(&onceToken, ^{
        imgRegex = [[NSRegularExpression alloc] initWithPattern:@"<img[^>]*class=[\\\"|\\'].*?[\\\"|\\'][^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSArray *matchs = [imgRegex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return matchs;
}

- (NSArray *)searchImgDivAndImgRangeFromContent
{
    static dispatch_once_t onceToken;
    static NSRegularExpression *img2Regex;
    dispatch_once(&onceToken, ^{
        img2Regex = [[NSRegularExpression alloc] initWithPattern:@"<img[^>]*class=[^>]*src=[\\\"|\\'](.*?)[\\\"|\\'][^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSArray *matchs = [img2Regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return matchs;
}

- (NSString *)deleteAllDivExpectImgDivFromContent
{
    static dispatch_once_t onceToken;
    static NSRegularExpression *divRegex;
    static NSRegularExpression *brRegex;
    dispatch_once(&onceToken, ^{
        brRegex = [[NSRegularExpression alloc] initWithPattern:@"<[^>]*\\/p>" options:NSRegularExpressionCaseInsensitive error:nil];
        divRegex = [[NSRegularExpression alloc] initWithPattern:@"(<p>|<[^i]{1}[^>]*>)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    NSArray *matchs = [brRegex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSString *strRet = self;

    NSInteger rangeOffset = 0;
    NSString *strDest = @"\n";
    for (NSTextCheckingResult *match in matchs) {
        NSRange srcRange = NSMakeRange([match rangeAtIndex:0].location + rangeOffset, [match rangeAtIndex:0].length);
//        NSString *strSrc = [self substringWithRange:srcRange];
//        Vlog(@"---\n%@", NSStringFromRange(srcRange));
        strRet = [strRet stringByReplacingCharactersInRange:srcRange withString:strDest];
//        Vlog(@"---\n%@", strRet);
        rangeOffset += strDest.length - srcRange.length;
    }
//    Vlog(@"%@", strRet);
    matchs = [divRegex matchesInString:strRet options:0 range:NSMakeRange(0, strRet.length)];
    
    rangeOffset = 0;
    strDest = @"";
    for (NSTextCheckingResult *match in matchs) {
        NSRange srcRange = NSMakeRange([match rangeAtIndex:0].location + rangeOffset, [match rangeAtIndex:0].length);
        //        NSString *strSrc = [self substringWithRange:srcRange];
//        Vlog(@"---\n%@", NSStringFromRange(srcRange));
//        Vlog(@"---\n%@", [strRet substringWithRange:srcRange]);
        strRet = [strRet stringByReplacingCharactersInRange:srcRange withString:strDest];
        
        rangeOffset += strDest.length - srcRange.length;
    }
//    Vlog(@"%@", strRet);
    return strRet;
}

@end
