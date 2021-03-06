//
//  BBAudio.m
//  bbnote
//
//  Created by bob on 13-8-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BB_BBAudio.h"
#import "BB_BBRecord.h"
#import "BAudio.h"
#import "NSString+UUID.h"

@implementation BB_BBAudio

@dynamic create_date;
@dynamic data_path;
@dynamic key;
@dynamic openupload;
@dynamic size;
@dynamic times;
@dynamic update;
@dynamic record;

+ (BB_BBAudio *)BBAudioWithBAudio:(BAudio *)baudio
{
    BB_BBAudio *bbaudio = nil;
    NSArray *array = [BB_BBAudio whereFormat:@"key == '%@'", baudio.key];
    if(array && array.count > 0)
    {
        bbaudio = array.first;
    }
    else
    {
        bbaudio = [BB_BBAudio create];
    }
    
    bbaudio.create_date = baudio.create_date;
    bbaudio.data_path = baudio.data_path;
    bbaudio.size = baudio.size;
    bbaudio.times = baudio.times;
    bbaudio.update = baudio.update;
    bbaudio.openupload = baudio.openupload;
    bbaudio.key = [NSString generateKey];
    return bbaudio;
}

- (NSDictionary *)covertDictionary
{
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithCapacity:8];
    [mulDic setObject:self.create_date forKey:@"create_date"];
    [mulDic setObject:self.data_path forKey:@"data_path"];
    [mulDic setObject:self.key forKey:@"key"];
//    [mulDic setObject:self.openupload forKey:@"openupload"];
//    [mulDic setObject:self.size forKey:@"size"];
//    [mulDic setObject:self.times forKey:@"times"];
//    [mulDic setObject:self.update forKey:@"update"];
    return mulDic;
}


@end
