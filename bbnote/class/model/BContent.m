//
//  BBContent.m
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BContent.h"
#import "DataManager.h"
#import "BBContent.h"

@implementation BContent

@synthesize text;
@synthesize create_date;
@synthesize modify_date;
@synthesize text_color;
@synthesize font;
@synthesize fontsize;

- (id)init{
    if(self = [super init])
    {
        self.create_date = [NSDate date];
        self.modify_date = self.create_date;
        self.text_color = [[DataManager ShareInstance] noteSetting].strTextColor;
        self.fontsize = [[DataManager ShareInstance] noteSetting].nFontSize;
        self.font = [[DataManager ShareInstance] noteSetting].strFontName;
        self.text = @"";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.create_date forKey:@"create_date"];
    [aCoder encodeObject:self.modify_date forKey:@"modify_date"];
    [aCoder encodeObject:self.text_color forKey:@"text_color"];
    [aCoder encodeObject:self.font forKey:@"font"];
    [aCoder encodeObject:self.fontsize forKey:@"fontsize"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.create_date = [aDecoder decodeObjectForKey:@"create_date"];
        self.modify_date = [aDecoder decodeObjectForKey:@"modify_date"];
        self.text_color = [aDecoder decodeObjectForKey:@"text_color"];
        self.font = [aDecoder decodeObjectForKey:@"font"];
        self.fontsize = [aDecoder decodeObjectForKey:@"fontsize"];
    }
    return self;
}
- (instancetype)initWithBBText:(BBText *)bbtext
{
    if(self = [super init])
    {
        self.text = bbtext.text;
        self.create_date = bbtext.create_date;
        self.modify_date = bbtext.modify_date;
        self.text_color = bbtext.text_color;
        self.font = bbtext.font;
        self.fontsize = bbtext.fontsize;
    }
    return self;
}
@end
