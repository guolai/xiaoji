//
//  BBContent.m
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BContent.h"
#import "DataManager.h"
#import "BB_BBContent.h"
#import "BB_BBLine.h"
#import "BLine.h"

@implementation BContent

@synthesize text;
@synthesize create_date;
@synthesize modify_date;


- (id)init{
    if(self = [super init])
    {
        self.create_date = [NSDate date];
        self.modify_date = self.create_date;
        self.text = @"";
        self.arrayLine = [NSMutableArray array];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.create_date forKey:@"create_date"];
    [aCoder encodeObject:self.modify_date forKey:@"modify_date"];
    [aCoder encodeObject:self.arrayLine forKey:@"arrayLine"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.create_date = [aDecoder decodeObjectForKey:@"create_date"];
        self.modify_date = [aDecoder decodeObjectForKey:@"modify_date"];
        self.arrayLine = [aDecoder decodeObjectForKey:@"arrayLine"];

    }
    return self;
}
- (instancetype)initWithBBText:(BB_BBText *)bbtext
{
    if(self = [super init])
    {
        self.text = bbtext.text;
        self.create_date = bbtext.create_date;
        self.modify_date = bbtext.modify_date;
        NSArray *array = [bbtext.lineInText allObjects];
        self.arrayLine = [NSMutableArray array];
        for (int i = 0; i < array.count; i++)
        {
            BB_BBLine  *bbline = [array objectAtIndex:i];
            BLine *bline = [[BLine alloc] initWithBBLine:bbline];
            [bbline delete];
            [self.arrayLine addObject:bline];
        }
    }
    return self;
}
@end
