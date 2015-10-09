//
//  NoteSetting.m
//  bbnotes
//
//  Created by bob on 6/3/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "NoteSetting.h"

@implementation NoteSetting
@synthesize isUseBgImg;
@synthesize strBgImg;
@synthesize strBgColor;
@synthesize strTextColor;
@synthesize strFontName;
@synthesize nFontSize;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.isUseBgImg forKey:@"isUseBgImg"];
    [aCoder encodeObject:self.strBgImg forKey:@"strBgImg"];
    [aCoder encodeObject:self.strBgColor forKey:@"strBgColor"];
    [aCoder encodeObject:self.strTextColor forKey:@"strTextColor"];
    [aCoder encodeObject:self.strFontName forKey:@"strFontName"];
    [aCoder encodeObject:self.nFontSize forKey:@"nFontSize"];
    [aCoder encodeObject:self.strLink forKey:@"strLink"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.isUseBgImg = [aDecoder decodeBoolForKey:@"isUseBgImg"];
        self.strBgImg = [aDecoder decodeObjectForKey:@"strBgImg"];
        self.strBgColor = [aDecoder decodeObjectForKey:@"strBgColor"];
        self.strTextColor = [aDecoder decodeObjectForKey:@"strTextColor"];
        self.strFontName = [aDecoder decodeObjectForKey:@"strFontName"];
        self.nFontSize = [aDecoder decodeObjectForKey:@"nFontSize"];
        self.strLink = [aDecoder decodeObjectForKey:@"strLink"];
    }
    return self;
}

@end
