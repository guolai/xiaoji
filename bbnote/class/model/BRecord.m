//
//  BBRecord.m
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BRecord.h"
#import "NSString+UUID.h"
#import "BB_BBRecord.h"

@implementation BRecord

@synthesize create_date;
@synthesize mood;
@synthesize mood_count;
@synthesize isVideo;
@synthesize title;
@synthesize shared_type;
@synthesize bg_image;
@synthesize bg_color;
@synthesize title_color;
@synthesize bg_music;
@synthesize isopen_music;
@synthesize year_month;
@synthesize location;
@synthesize lookup;
@synthesize key;
@synthesize isDemo;


- (id)init{
    if(self = [ super init])
    {
        self.mood = [NSNumber numberWithInt:1];
        self.mood_count =[NSNumber numberWithInt:1];
        self.isVideo = [NSNumber numberWithBool:NO];
        self.lookup = [NSNumber numberWithInt:1];
        self.shared_type = [NSNumber numberWithInt:0];
        self.create_date = [NSDate date];
        self.key = [NSString generateKey];
        self.isDemo = [NSNumber numberWithBool:NO];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.create_date forKey:@"create_date"];
    [aCoder encodeObject:self.mood forKey:@"mood"];
    [aCoder encodeObject:self.mood_count forKey:@"mood_count"];
    [aCoder encodeObject:self.isVideo forKey:@"isVideo"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.shared_type forKey:@"shared_type"];
    [aCoder encodeObject:self.bg_image forKey:@"bg_image"];
    [aCoder encodeObject:self.bg_color forKey:@"bg_color"];
    [aCoder encodeObject:self.title_color forKey:@"title_color"];
    [aCoder encodeObject:self.bg_music forKey:@"bg_music"];
    [aCoder encodeObject:self.isopen_music forKey:@"isopen_music"];
    [aCoder encodeObject:self.year_month forKey:@"year_month"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.lookup forKey:@"lookup"];
    [aCoder encodeObject:self.isDemo forKey:@"isDemo"];
    [aCoder encodeObject:self.key forKey:@"key"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.create_date = [aDecoder decodeObjectForKey:@"create_date"];
        self.mood = [aDecoder decodeObjectForKey:@"mood"];
        self.mood_count = [aDecoder decodeObjectForKey:@"mood_count"];
        self.isVideo = [aDecoder decodeObjectForKey:@"isVideo"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.shared_type = [aDecoder decodeObjectForKey:@"shared_type"];
        self.bg_image = [aDecoder decodeObjectForKey:@"bg_image"];
        self.bg_color = [aDecoder decodeObjectForKey:@"bg_color"];
        self.title_color = [aDecoder decodeObjectForKey:@"title_color"];
        self.bg_music = [aDecoder decodeObjectForKey:@"bg_music"];
        self.isopen_music = [aDecoder decodeObjectForKey:@"isopen_music"];
        self.year_month = [aDecoder decodeObjectForKey:@"year_month"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.lookup = [aDecoder decodeObjectForKey:@"lookup"];
        self.isDemo = [aDecoder decodeObjectForKey:@"isDemo"];
        self.key = [aDecoder decodeObjectForKey:@"key"];
    }
    return self;
}

- (instancetype)initWithBBrecord:(BB_BBRecord *)bbrecord
{
    if(self = [super init])
    {
        self.create_date = bbrecord.create_date;
        self.mood = bbrecord.mood;
        self.mood_count = bbrecord.mood_count;
        self.isVideo = bbrecord.isVideo;
        self.title = bbrecord.title;
        self.shared_type = bbrecord.shared_type;
        self.bg_image = bbrecord.bg_image;
        self.bg_color = bbrecord.bg_color;
        self.title_color = bbrecord.title_color;
        self.bg_music = bbrecord.bg_music;
        self.isopen_music = bbrecord.isopen_music;
        self.year_month = bbrecord.year_month;
        self.location = bbrecord.location;
        self.lookup = bbrecord.lookup;
        self.isDemo = bbrecord.isDemo;
        self.key = bbrecord.key;
    }
    return self;
}

@end
