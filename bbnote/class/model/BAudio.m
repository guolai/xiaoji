//
//  BBAudio.m
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BAudio.h"
#import "BBAudio.h"
#import "NSString+UUID.h"

@implementation BAudio

@synthesize create_date;
@synthesize data_path;
@synthesize size;
@synthesize times;
@synthesize update;
@synthesize openupload;
@synthesize key;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.create_date forKey:@"create_date"];
    [aCoder encodeObject:self.data_path forKey:@"data_path"];
    [aCoder encodeObject:self.size forKey:@"size"];
    [aCoder encodeObject:self.times forKey:@"times"];
    [aCoder encodeObject:self.update forKey:@"update"];
    [aCoder encodeObject:self.openupload forKey:@"openupload"];
    [aCoder encodeObject:self.key forKey:@"key"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.create_date = [aDecoder decodeObjectForKey:@"create_date"];
        self.data_path = [aDecoder decodeObjectForKey:@"data_path"];
        self.size = [aDecoder decodeObjectForKey:@"size"];
        self.times = [aDecoder decodeObjectForKey:@"times"];
        self.update = [aDecoder decodeObjectForKey:@"update"];
        self.openupload = [aDecoder decodeObjectForKey:@"openupload"];
        self.key = [aDecoder decodeObjectForKey:@"key"];
    }
    return self;
}

- (instancetype)initWithBBAudio:(BBAudio *)bbaudio
{
    if(self = [super init])
    {
        self.create_date = bbaudio.create_date;
        self.data_path = bbaudio.data_path;
        self.size = bbaudio.size;
        self.times = bbaudio.times;
        self.update = bbaudio.update;
        self.openupload = bbaudio.openupload;
        self.key = bbaudio.key;
    }
    return self;
}

- (id)init{
    if(self = [ super init])
    {
        self.create_date = [NSDate date];
        self.key = [NSString generateKey];
        self.data_path = [NSString stringWithFormat:@"%@.caf", self.key];
    }
    return self;
}
@end
