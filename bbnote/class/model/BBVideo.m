//
//  BBVideo.m
//  bbnote
//
//  Created by bob on 13-8-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBVideo.h"
#import "BBRecord.h"
#import "BVideo.h"
#import "NSString+UUID.h"

@implementation BBVideo

@dynamic create_date;
@dynamic data_path;
@dynamic key;
@dynamic openupload;
@dynamic size;
@dynamic times;
@dynamic update;
@dynamic record;

+ (BBVideo *)BBVideoWithBVideo:(BVideo *)bvideo
{
    BBVideo *bbvideo = nil;
    NSArray *array = [BBVideo whereFormat:@"key == '%@'", bvideo.key];
    if(array && array.count > 0)
    {
        bbvideo = array.first;
    }
    else
    {
        bbvideo = [BBVideo create];
    }
    bbvideo.create_date = bvideo.create_date;
    bbvideo.data_path = bvideo.data_path;
    bbvideo.size = bvideo.size;
    bbvideo.times = bvideo.times;
    bbvideo.update = bvideo.update;
    bbvideo.openupload = bvideo.openupload;
    bbvideo.key = [NSString generateKey];
    return bbvideo;
}
- (NSDictionary *)covertDictionary
{
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithCapacity:10];
    [mulDic setObject:self.create_date forKey:@"create_date"];
    [mulDic setObject:self.data_path forKey:@"data_path"];
//    [mulDic setObject:self.size forKey:@"size"];
//    [mulDic setObject:self.times forKey:@"times"];
//    [mulDic setObject:self.update forKey:@"update"];
//    [mulDic setObject:self.openupload forKey:@"openupload"];
    [mulDic setObject:self.key forKey:@"key"];
    return mulDic;
}
@end
