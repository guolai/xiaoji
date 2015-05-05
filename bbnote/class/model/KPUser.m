//
//  KPUser.m
//  bbnote
//
//  Created by Apple on 13-6-6.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "KPUser.h"

@implementation KPUser
@synthesize userID;
@synthesize userName;
@synthesize maxFileSize;
@synthesize quotaTotal;
@synthesize quotaUsed;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.maxFileSize forKey:@"maxFileSize"];
    [aCoder encodeObject:self.quotaUsed forKey:@"quotaUsed"];
    [aCoder encodeObject:self.quotaTotal forKey:@"quotaTotal"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.maxFileSize = [aDecoder decodeObjectForKey:@"maxFileSize"];
        self.quotaUsed = [aDecoder decodeObjectForKey:@"quotaUsed"];
        self.quotaTotal = [aDecoder decodeObjectForKey:@"quotaTotal"];
    }
    return self;
}

@end
