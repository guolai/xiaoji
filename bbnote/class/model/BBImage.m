//
//  BBImage.m
//  bbnote
//
//  Created by bob on 13-8-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBImage.h"
#import "BBRecord.h"
#import "BImage.h"
#import "NSString+UUID.h"

@implementation BBImage

@dynamic create_date;
@dynamic data_path;
@dynamic data_small_path;
@dynamic height;
@dynamic iscontent;
@dynamic key;
@dynamic openupload;
@dynamic reserve;
@dynamic size;
@dynamic update;
@dynamic vertical;
@dynamic width;
@dynamic record;

+(BBImage *)BBImageWithBImage:(BImage *)bimg
{
    BBImage *bbimage = nil;
    NSArray *array = [BBImage whereFormat:@"key == '%@'", bimg.key];
    if(array && array.count > 0)
    {
        bbimage = array.first;
    }
    else
    {
        bbimage = [BBImage create];
    }
    bbimage.create_date = bimg.create_date;
    bbimage.data_path = bimg.data_path;
    bbimage.data_small_path = bimg.data_small_path;
    bbimage.size = bimg.size;
    bbimage.width = bimg.width;
    bbimage.height = bimg.height;
    bbimage.vertical = bimg.vertical;
    bbimage.iscontent = bimg.iscontent;
    bbimage.update = bimg.update;
    bbimage.openupload = bimg.openupload;
    bbimage.key = [NSString generateKey];
    return  bbimage;
}
- (NSDictionary *)covertDictionary
{
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithCapacity:10];
    [mulDic setObject:self.create_date forKey:@"create_date"];
    if (self.data_path)
    [mulDic setObject:self.data_path forKey:@"data_path"];
    if (self.data_small_path) 
    [mulDic setObject:self.data_small_path forKey:@"data_small_path"];
    [mulDic setObject:self.size forKey:@"size"];
    [mulDic setObject:self.width forKey:@"width"];
    [mulDic setObject:self.height forKey:@"height"];
//    [mulDic setObject:self.vertical forKey:@"vertical"];
    [mulDic setObject:self.iscontent forKey:@"iscontent"];
//    [mulDic setObject:self.update forKey:@"update"];
//    [mulDic setObject:self.openupload forKey:@"openupload"];
    [mulDic setObject:self.key forKey:@"key"];
    return mulDic;
}

@end
