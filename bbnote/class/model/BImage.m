//
//  BBImage.m
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BImage.h"
#import "BB_BBImage.h"
#import "NSString+UUID.h"

@implementation BImage

@synthesize create_date;
@synthesize data_path;
@synthesize data_small_path;
@synthesize size;
@synthesize width;
@synthesize height;
@synthesize vertical;
@synthesize assetPath;
@synthesize iscontent;
@synthesize update;
@synthesize openupload;
@synthesize key;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.create_date forKey:@"create_date"];
    [aCoder encodeObject:self.data_path forKey:@"data_path"];
    [aCoder encodeObject:self.data_small_path forKey:@"data_small_path"];
    [aCoder encodeObject:self.size forKey:@"size"];
    [aCoder encodeObject:self.width forKey:@"width"];
    [aCoder encodeObject:self.height forKey:@"height"];
    [aCoder encodeObject:self.vertical forKey:@"vertical"];
    [aCoder encodeObject:self.assetPath forKey:@"assetPath"];
    [aCoder encodeObject:self.iscontent forKey:@"iscontent"];
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
        self.data_small_path = [aDecoder decodeObjectForKey:@"data_small_path"];
        self.size = [aDecoder decodeObjectForKey:@"size"];
        self.width = [aDecoder decodeObjectForKey:@"width"];
        self.height = [aDecoder decodeObjectForKey:@"height"];
        self.vertical = [aDecoder decodeObjectForKey:@"vertical"];
        self.assetPath = [aDecoder decodeObjectForKey:@"assetPath"];
        self.iscontent = [aDecoder decodeObjectForKey:@"iscontent"];
        self.update = [aDecoder decodeObjectForKey:@"update"];
        self.openupload = [aDecoder decodeObjectForKey:@"openupload"];
        self.key = [aDecoder decodeObjectForKey:@"key"];
    }
    return self;
}

- (instancetype)initWithBBImage:(BB_BBImage *)bbimage
{
    if (self = [super init]) {
        self.create_date = bbimage.create_date;
        self.data_path = bbimage.data_path;
        self.data_small_path  = bbimage.data_small_path;
        self.size = bbimage.size;
        self.width = bbimage.width;
        self.height = bbimage.height;
        self.vertical = bbimage.vertical;
        self.iscontent = bbimage.iscontent;
        self.update = bbimage.update;
        self.openupload = bbimage.openupload;
        self.key = bbimage.key;
    }
    return self;
}

- (id)init{
    if(self = [ super init])
    {
        self.create_date = [NSDate date];
        self.key = [NSString generateKey];
        self.data_path = [NSString stringWithFormat:@"%@.jpg", self.key];
        self.data_small_path  = [NSString stringWithFormat:@"%@sml.jpg", self.key];
    }
    return self;
}
@end
