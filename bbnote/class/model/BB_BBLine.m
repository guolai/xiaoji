//
//  BB_BBLine.m
//  bbnote
//
//  Created by bob on 11/22/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import "BB_BBLine.h"
#import "BLine.h"

@implementation BB_BBLine
@dynamic line;
@dynamic run;
@dynamic location;
@dynamic length;
@dynamic fontname;
@dynamic fontsize;
@dynamic forcolor;
@dynamic bgcolor;
@dynamic text;

//img
@dynamic fileName;
@dynamic displaySizeW;
@dynamic displaySizeH;
@dynamic orgiSizeW;
@dynamic orgiSizeH;
@dynamic bText;


+ (BB_BBLine * _Nonnull)BBLineCreateWithBContent:(BLine * _Nonnull)bline
{
    BB_BBLine *bbline = [BB_BBLine create];
    bbline.bgcolor = bline.bgcolor;
    bbline.forcolor = bline.forcolor;
    bbline.line = [NSNumber numberWithUnsignedInteger:bline.line];
    bbline.run = [NSNumber numberWithUnsignedInteger:bline.run];
    bbline.location = [NSNumber numberWithUnsignedInteger:bline.location];
    bbline.length = [NSNumber numberWithUnsignedInteger:bline.length];
    bbline.fontname = bline.fontname;
    bbline.fontsize = bline.fontsize;
    bbline.text = bline.text;
    if (bline.fileName)
    {
        bbline.fileName = bline.fileName;
        bbline.displaySizeW = [NSNumber numberWithDouble:bline.displaySizeW];
        bbline.displaySizeH = [NSNumber numberWithDouble:bline.displaySizeH];
        bbline.orgiSizeW = [NSNumber numberWithDouble:bline.orgiSizeW];
        bbline.orgiSizeH = [NSNumber numberWithDouble:bline.orgiSizeH];
    }
    return bbline;
}

//- (NSDictionary * _Nonnull)covertDictionary
//{
//    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithCapacity:10];
//    [mulDic setObject:self.bgcolor forKey:@"bgcolor"];
//    [mulDic setObject:self.forcolor forKey:@"forcolor"];
//    [mulDic setObject:self.line forKey:@"line"];
//    [mulDic setObject:self.run forKey:@"run"];
//    [mulDic setObject:self.location forKey:@"location"];
//    [mulDic setObject:self.length forKey:@"length"];
//    [mulDic setObject:self.fontname forKey:@"fontname"];
//    [mulDic setObject:self.fontsize forKey:@"fontsize"];
//    [mulDic setObject:self.text forKey:@"text"];
//    if (self.fileName)
//    {
//        [mulDic setObject:self.fileName forKey:@"fileName"];
//        [mulDic setObject:self.displaySizeW forKey:@"displaySizeW"];
//        [mulDic setObject:self.displaySizeH forKey:@"displaySizeH"];
//        [mulDic setObject:self.orgiSizeW forKey:@"orgiSizeW"];
//        [mulDic setObject:self.orgiSizeH forKey:@"orgiSizeH"];
//    }
//    
//    
//    return mulDic;
//}
@end
