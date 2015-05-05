//
//  BBRecord.m
//  bbnote
//
//  Created by bob on 13-8-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBRecord.h"
#import "BBAudio.h"
#import "BBContent.h"
#import "BBImage.h"
#import "BBVideo.h"

#import "BImage.h"
#import "BAudio.h"
#import "BVideo.h"
#import "BRecord.h"
#import "BContent.h"

@implementation BBRecord

@dynamic bg_color;
@dynamic bg_image;
@dynamic bg_music;
@dynamic create_date;
@dynamic isopen_music;
@dynamic isVideo;
@dynamic key;
@dynamic location;
@dynamic lookup;
@dynamic mood;
@dynamic mood_count;
@dynamic shared_type;
@dynamic title;
@dynamic title_color;
@dynamic year_month;
@dynamic audioInRecord;
@dynamic isDemo;
@dynamic contentInRecord;
@dynamic imageInRecord;
@dynamic videoInRecord;


//+ (void)saveBBRecordWithBRecord:(BRecord *)brecord content:(BContent *)bContent imageArray:(NSArray *)imgArray audioArray:(NSArray *)audioArry videoArray:(NSArray *)videoArry
//{
//    BBRecord *bbrecord = nil;
//    BBText *bbcontent = nil;
//    NSMutableDictionary *savedic = [NSMutableDictionary dictionaryWithCapacity:10];
//    NSArray *array = [BBRecord whereFormat:@"key == '%@'", brecord.key];
//    if(array && array.count > 0)
//    {
//        bbrecord = array.first;
//        bbcontent = bbrecord.contentInRecord;
//        [bbcontent updateWithBContent:bContent];
//    }
//    else
//    {
//        bbrecord = [BBRecord initWithBRecord:brecord];
//        bbcontent = [BBText BBContentWithBContent:bContent];
//        bbrecord.contentInRecord = bbcontent;
//    }
//    [bbcontent save];
//    
//   
//    if(imgArray && imgArray.count > 0)
//    {
//        for(BImage *bimage in imgArray)
//        {
//            BBImage *bbimage = [BBImage BBImageWithBImage:bimage];
//            bbimage.record = bbrecord;
//        }
//    }
//    if(audioArry && audioArry.count > 0)
//    {
//        for (BAudio *baudio in audioArry) {
//            BBAudio *bbaudio = [BBAudio BBAudioWithBAudio:baudio];
//            bbaudio.record = bbrecord;
//        }
//    }
//    if(videoArry && videoArry.count > 0)
//    {
//        for (BVideo *bvideo in videoArry) {
//            BBVideo *bbvideo = [BBVideo BBVideoWithBVideo:bvideo];
//            bbvideo.record = bbrecord;
//        }
//    }
//    [bbrecord save];
//}

+ (BBRecord *)initWithBRecord:(BRecord *)brecord
{
    if(!brecord)
        return nil;
    BBRecord *bbrecord = nil;
    NSArray *array = [BBRecord whereFormat:@"key == '%@'", brecord.key];
    if(array && array.count > 0)
    {
        bbrecord = array.first;
    }
    else
    {
        bbrecord = [BBRecord create];
    }
    bbrecord.create_date = brecord.create_date;
    bbrecord.mood = brecord.mood;
    bbrecord.mood_count = brecord.mood_count;
    bbrecord.isVideo = brecord.isVideo;
    bbrecord.title = brecord.title;
    bbrecord.shared_type = brecord.shared_type;
    bbrecord.bg_image = brecord.bg_image;
    bbrecord.bg_color = brecord.bg_color;
    bbrecord.title_color = brecord.title_color;
    bbrecord.bg_music = brecord.bg_music;
    bbrecord.isopen_music = brecord.isopen_music;
    bbrecord.year_month = brecord.year_month;
    bbrecord.location = brecord.location;
    bbrecord.lookup = brecord.lookup;
    bbrecord.key = brecord.key;
    bbrecord.isDemo = brecord.isDemo;
    return bbrecord;
}
+ (NSString *)getRecordMoodStr:(BBRecord *)recd
{
    NSString  *strMood = [NSString stringWithFormat:@"%.3i.png",[recd.mood integerValue]];
    if([recd.mood integerValue] <= 0)
    {
        strMood = @"001.png";
    }
    return strMood;
}
- (NSDictionary *)covertDictionary
{
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithCapacity:10];
    [mulDic setObject:self.create_date forKey:@"create_date"];
    [mulDic setObject:self.mood forKey:@"mood"];
    [mulDic setObject:self.mood_count forKey:@"mood_count"];
    [mulDic setObject:self.isVideo forKey:@"isVideo"];
    if(self.title)
        [mulDic setObject:self.title forKey:@"title"];
    if(self.shared_type)
        [mulDic setObject:self.shared_type forKey:@"shared_type"];
    if(self.bg_image)
        [mulDic setObject:self.bg_image forKey:@"bg_image"];
    if(self.bg_color)
        [mulDic setObject:self.bg_color forKey:@"bg_color"];
    if(self.title_color)
        [mulDic setObject:self.title_color forKey:@"title_color"];
//    [mulDic setObject:self.bg_music forKey:@"bg_music"];
//    [mulDic setObject:self.isopen_music forKey:@"isopen_music"];
    if(self.location)
        [mulDic setObject:self.location forKey:@"location"];
//    [mulDic setObject:self.lookup forKey:@"lookup"];
    [mulDic setObject:self.key forKey:@"key"];
    return mulDic;
}

- (void)saveToSandBoxPath:(NSString *)strFolder
{
    strFolder = [strFolder stringByAppendingPathComponent:@"note.plist"];
    NSMutableDictionary *muldic = [NSMutableDictionary dictionaryWithCapacity:10];
    NSDictionary *recordDic = [self covertDictionary];
    BBINFO(@"11 %@", recordDic);
    [muldic setObject:recordDic forKey:@"record"];
    BBText *bbtext = self.contentInRecord;
    NSDictionary *textDic = [bbtext covertDictionary];
    [muldic setObject:textDic forKey:@"text"];
    BBINFO(@"22 %@", recordDic);
    
    NSMutableArray *mulArray = [NSMutableArray arrayWithCapacity:10];
    for (BBImage *bbimeage in [self.imageInRecord allObjects]) {
        NSDictionary *imageDic = [bbimeage covertDictionary];
        BBINFO(@"33 %@", imageDic);
        [mulArray addObject:imageDic];
    }
    if (mulArray.count > 0) {
        [muldic setObject:mulArray forKey:@"images"];
    }
    
    [mulArray removeAllObjects];
    for (BBAudio *bbaudio in [self.audioInRecord allObjects]) {
        NSDictionary *dic = [bbaudio covertDictionary];
        BBINFO(@"44 %@", dic);
        [mulArray addObject:dic];
    }
    if (mulArray.count > 0) {
        [muldic setObject:mulArray forKey:@"audio"];
    }
    
    [mulArray removeAllObjects];
    for (BBVideo *bbvideo in [self.videoInRecord allObjects]) {
        NSDictionary *dic = [bbvideo covertDictionary];
        BBINFO(@"55 %@", dic);
        [mulArray addObject:dic];
    }
    if (mulArray.count > 0) {
        [muldic setObject:mulArray forKey:@"video"];
    }
    
    [muldic writeToFile:strFolder atomically:YES];
}
@end
