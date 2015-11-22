//
//  NSString+Help.h
//  jyy
//
//  Created by bob on 2/20/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Help)
- (NSString *)trimString;
- (NSString *)getNetUrl;
- (UIColor *)getColorFromString;

- (NSString *)getNumFromDate;
- (NSString *)getNUmFromTime;
- (NSString *)getDate;
- (NSString *)getTime;

+ (NSString *)keyForFilePath:(NSString *)strFilePath;

- (NSString *)substringSafeWithRange:(NSRange)range; //如果range 不对，返回自身

@end
