//
//  NSString+UUID.h
//  Zine
//
//  Created by bob on 13-9-13.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UUID)
+(NSString *)generateKey;//根据uuid生成唯一标识
- (BOOL)isValidateEmail;
- (BOOL)isValidatePassword;
- (NSArray *)searchModelImgDivFromContent;
- (NSArray *)searchLocaImgDivFromContent;
- (NSArray *)searchServerImgDivFromContent;

@end
