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
#import "BB_BBLine.h"
#import "BLine.h"

@implementation BB_BBText

@dynamic create_date;
@dynamic modify_date;
@dynamic text;
@dynamic lineInText;
@dynamic record;


+ (BB_BBText *)BBContentWithBContent:(BContent *)bContent
{
    NSLog(@"%@", NSStringFromClass(self));
//    if(!bContent)
//        return nil;
    BB_BBText *bbContent = [BB_BBText create];
    [bbContent updateWithBContent:bContent];
    return bbContent;
}

- (void)updateWithBContent:(BContent *)bcontent
{
    self.text = bcontent.text;
    self.create_date = bcontent.create_date;
    self.modify_date = bcontent.modify_date;
    for (int i = 0; i < bcontent.arrayLine.count; i ++)
    {
        BLine *bline = [bcontent.arrayLine objectAtIndex:i];
        BB_BBLine *bbline = [BB_BBLine BBLineCreateWithBContent:bline];
        bbline.bText = self;
    }
 
}
//- (NSDictionary *)covertDictionary
//{
//    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithCapacity:10];
//    [mulDic setObject:self.create_date forKey:@"create_date"];
//    [mulDic setObject:self.modify_date forKey:@"modify_date"];
//    [mulDic setObject:self.text forKey:@"text"];
//    [mulDic setObject:self.lineInText forKey:<#(nonnull id<NSCopying>)#>]
//    return mulDic;
//}

@end
