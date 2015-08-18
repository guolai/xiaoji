//
//  BBContent.m
//  bbnote
//
//  Created by bob on 13-8-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BB_BBContent.h"
#import "BB_BBRecord.h"
#import "BContent.h"


//@implementation BBContent
//
//@dynamic create_date;
//@dynamic font;
//@dynamic fontsize;
//@dynamic modify_date;
//@dynamic reserve;
//@dynamic text;
//@dynamic text_color;
//@dynamic record;
//
//+ (BBContent *)BBContentWithBContent:(BContent *)bContent
//{
//    NSLog(@"%@", NSStringFromClass(self));
//    //    if(!bContent)
//    //        return nil;
//    BBText *bbContent = [BBText create];
//    bbContent.text = bContent.text;
//    bbContent.create_date = bContent.create_date;
//    bbContent.modify_date = bContent.modify_date;
//    bbContent.text_color = bContent.text_color;
//    bbContent.fontsize = bContent.fontsize;
//    bbContent.font = bContent.font;
//    bbContent.reserve = bContent.reserve;
//    return bbContent;
//}
//@end

@implementation BB_BBText

@dynamic create_date;
@dynamic font;
@dynamic fontsize;
@dynamic modify_date;

@dynamic text;
@dynamic text_color;
@dynamic record;

+ (BB_BBText *)BBContentWithBContent:(BContent *)bContent
{
    NSLog(@"%@", NSStringFromClass(self));
//    if(!bContent)
//        return nil;
    BB_BBText *bbContent = [BB_BBText create];
    bbContent.text = bContent.text;
    bbContent.create_date = bContent.create_date;
    bbContent.modify_date = bContent.modify_date;
    bbContent.text_color = bContent.text_color;
    bbContent.fontsize = bContent.fontsize;
    bbContent.font = bContent.font;
    return bbContent;
}

- (void)updateWithBContent:(BContent *)bcontent
{
    self.text = bcontent.text;
//    self.create_date = bcontent.create_date;

    self.font = bcontent.font;
    self.fontsize = bcontent.fontsize;
    self.modify_date = bcontent.modify_date;
    self.text_color = bcontent.text_color;
}
- (NSDictionary *)covertDictionary
{
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithCapacity:10];
    [mulDic setObject:self.create_date forKey:@"create_date"];
    if(self.font)
    [mulDic setObject:self.font forKey:@"font"];
    [mulDic setObject:self.fontsize forKey:@"fontsize"];
    [mulDic setObject:self.modify_date forKey:@"modify_date"];
    [mulDic setObject:self.text forKey:@"text"];
    [mulDic setObject:self.text_color forKey:@"text_color"];
    return mulDic;
}

@end
