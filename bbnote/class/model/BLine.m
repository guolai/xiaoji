//
//  BLine.m
//  bbnote
//
//  Created by bob on 11/22/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import "BLine.h"
#import "NSMutableDictionary+SafeSet.h"
#import "NSString+UIColor.h"
#import "DataModel.h"
#import "BB_BBLine.h"

@implementation BLine

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.forcolor forKey:@"forcolor"];
    [aCoder encodeObject:self.bgcolor forKey:@"bgcolor"];
    [aCoder encodeObject:self.fontname forKey:@"fontname"];
    [aCoder encodeObject:self.fontsize forKey:@"fontsize"];
    [aCoder encodeInteger:self.line forKey:@"line"];
    [aCoder encodeInteger:self.run forKey:@"run"];
    [aCoder encodeInteger:self.location forKey:@"location"];
    [aCoder encodeInteger:self.length forKey:@"length"];
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeDouble:self.displaySizeW forKey:@"displaySizeW"];
    [aCoder encodeDouble:self.displaySizeH forKey:@"displaySizeH"];
    [aCoder encodeDouble:self.orgiSizeW forKey:@"orgiSizeW"];
    [aCoder encodeDouble:self.orgiSizeH forKey:@"orgiSizeH"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.forcolor = [aDecoder decodeObjectForKey:@"forcolor"];
        self.bgcolor = [aDecoder decodeObjectForKey:@"bgcolor"];
        self.fontname = [aDecoder decodeObjectForKey:@"fontname"];
        self.fontsize = [aDecoder decodeObjectForKey:@"fontsize"];
        self.line = [aDecoder decodeIntegerForKey:@"line"];
        self.run = [aDecoder decodeIntegerForKey:@"run"];
        self.location = [aDecoder decodeIntegerForKey:@"location"];
        self.length = [aDecoder decodeIntegerForKey:@"length"];
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        
        self.displaySizeW = [aDecoder decodeDoubleForKey:@"displaySizeW"];
        self.displaySizeH = [aDecoder decodeDoubleForKey:@"displaySizeH"];
        self.orgiSizeW = [aDecoder decodeDoubleForKey:@"orgiSizeW"];
        self.orgiSizeH = [aDecoder decodeDoubleForKey:@"orgiSizeH"];
    }
    return self;
}


- (instancetype)init
{
    if(self = [super init])
    {
        self.forcolor = @"rgba(0,0,0,1.0)";
        self.bgcolor = @"rgba(255,255,255,0.0)";
        self.fontname = kDefatultFont;
        self.fontsize = @"12";
        self.line = 0;
        self.run = 0;
        self.location = 0;
        self.length = 0;
        self.text = @"";
    }
    return self;
}

- (CGSize)displaySize
{
    return CGSizeMake(self.displaySizeW, self.displaySizeH);
}

- (void)setDisplaySize:(CGSize)displaySize
{
    self.displaySizeW = displaySize.width;
    self.displaySizeH = displaySize.height;
}

- (CGSize)orgiSize
{
    return CGSizeMake(self.orgiSizeW, self.orgiSizeH);
}

- (void)setOrgiSize:(CGSize)orgiSize
{
    self.orgiSizeW = orgiSize.width;
    self.orgiSizeH = orgiSize.height;
}


- (instancetype _Nonnull)initWithBBLine:(BB_BBLine * _Nonnull)bbline
{
    if(self = [super init])
    {
        self.forcolor = bbline.forcolor;
        self.bgcolor = bbline.bgcolor;
        self.fontname = bbline.fontname;
        self.fontsize = bbline.fontsize;
        self.line = [bbline.line unsignedIntegerValue];
        self.run = [bbline.run unsignedIntegerValue];
        self.location = [bbline.location unsignedIntegerValue];
        self.length = [bbline.length unsignedIntegerValue];
        self.text = bbline.text;
        self.fileName = bbline.fileName;
        self.displaySizeW = [bbline.displaySizeW doubleValue];
        self.displaySizeH = [bbline.displaySizeH doubleValue];
        self.orgiSizeW = [bbline.orgiSizeW doubleValue];
        self.orgiSizeH = [bbline.orgiSizeH doubleValue];
    }
    return self;
}

- (NSAttributedString *)geneAttributedStringFromDir:(NSString *)strDir
{
    NSMutableAttributedString *tmpAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
    [dic bb_setSafeObject:[self.forcolor getColorFromCSSString] forKey:NSForegroundColorAttributeName];
    [dic  bb_setSafeObject:[self.bgcolor getColorFromCSSString] forKey:NSBackgroundColorAttributeName];
    UIFont *font = [UIFont fontWithName:[DataModel checkFontName:self.fontname] size:[self.fontsize floatValue]];
    [dic bb_setSafeObject:font forKey:NSFontAttributeName];
    
    CTParagraphStyleRef paragraphStyle = [[DTCoreTextParagraphStyle defaultParagraphStyle] createCTParagraphStyle];
    [dic bb_setSafeObject:(__bridge id)paragraphStyle forKey:NSParagraphStyleAttributeName];
    CFRelease(paragraphStyle);
    
    NSString *str = self.text;
    
    if (self.run == 0&& self.line != 0)
    {
        NSAttributedString *formattedNL = [[NSAttributedString alloc] initWithString:@"\n" attributes:dic];
        [tmpAttributedString appendAttributedString:formattedNL];
    }
    
    if (self.fileName)
    {
        UIImage *image = [UIImage imageWithContentsOfFile:[strDir stringByAppendingPathComponent:self.fileName]];
        ScaledBImage *scaleImage = [DataModel scaleImage:image];
        DTImageTextAttachment *attachment = [[DTImageTextAttachment alloc] initWithElement:nil options:nil];
        attachment.image = (id)scaleImage.imge;
        attachment.displaySize = scaleImage.displaySize;
        attachment.originalSize = scaleImage.originalSize;
        attachment.strFileName = self.fileName;
        
        CTRunDelegateRef embeddedObjectRunDelegate = createEmbeddedObjectRunDelegate((id)attachment);
        [dic setObject:(__bridge id)embeddedObjectRunDelegate forKey:(id)kCTRunDelegateAttributeName];
        CFRelease(embeddedObjectRunDelegate);
        
        // add attachment
        [dic setObject:attachment forKey:NSAttachmentAttributeName];
        
        NSAttributedString *tmpStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
        [tmpAttributedString appendAttributedString:tmpStr];
    }
    else
    {
        NSAttributedString  *string = [[NSAttributedString alloc] initWithString:str attributes:dic];
         [tmpAttributedString appendAttributedString:string];
    }

    return tmpAttributedString;
}

@end
