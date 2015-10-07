//
//  BBMisc.m
//  bbnotes
//
//  Created by bob on 5/27/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BBMisc.h"
#import "FileManagerController.h"
#import "NSDate+String.h"
#import "UIImage+SCaleImage.h"
#import "BBUserDefault.h"
#import "NSString+Help.h"
#import "DataManager.h"


@implementation BBMisc

+ (CGFloat)screenHeight
{
    static dispatch_once_t onceToken;
    static CGFloat screenHeight;
    dispatch_once(&onceToken, ^{
        screenHeight = [[UIScreen mainScreen] bounds].size.height;
    });
    return screenHeight;
}


+ (CGFloat)scrrenScaleSize
{
    CGFloat scale = 1.0;
    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)])
    {
        CGFloat tmp = [[UIScreen mainScreen] scale];
        if (tmp > 1.5)
        {
            scale = 2.0;
        }
    }
    return scale;
}

+ (CGSize)scaledSizeFromSize:(CGSize)fromSize toSize:(CGSize)toSize
{
    CGFloat fHeight = fromSize.height;
    CGFloat fWidth = fromSize.width;
    if(fHeight > fWidth)
    {
        
        float fScale = fWidth / toSize.width;
        float iHeight = fHeight / fScale;
        return CGSizeMake(toSize.width, iHeight);
    }
    else
    {
        float fScale = fHeight / toSize.height;
        float iWidth = fWidth / fScale;
        return CGSizeMake(iWidth, toSize.height);
    }
}

+ (NSArray *)getTwoImagePathWithPng:(BOOL)bValue
{
    NSString *strDate =[[NSDate date] qzgetDateTime];
    NSString *strPath = [[FileManagerController libraryPath] stringByAppendingPathComponent:NOTE_IMAGE_PATH];
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:2];
    if(bValue)
    {
        NSString *strBigPath = [NSString stringWithFormat:@"%@/%@.png", strPath, strDate];
        NSString *strSmalPath = [NSString stringWithFormat:@"%@/%@_sml.png", strPath, strDate];
        [mutArray addObject:strBigPath];
        [mutArray addObject:strSmalPath];
    }
    else
    {
        NSString *strBigPath = [NSString stringWithFormat:@"%@/%@.jpg", strPath, strDate];
        NSString *strSmalPath = [NSString stringWithFormat:@"%@/%@_sml.jpg", strPath, strDate];
        [mutArray addObject:strBigPath];
        [mutArray addObject:strSmalPath];
    }
    BBINFO(@"%@", mutArray);
    return mutArray;
}

+ (NSString *)getImagePathWithPng:(BOOL)bValue
{
    NSString *strPath = [[FileManagerController libraryPath] stringByAppendingPathComponent:NOTE_IMAGE_PATH];
    if(bValue)
        strPath = [NSString stringWithFormat:@"%@/%@.png", strPath, [[NSDate date] qzgetDateTime]];
    else
        strPath = [NSString stringWithFormat:@"%@/%@.jpg", strPath, [[NSDate date] qzgetDateTime]];
    return strPath;
}

+ (NSString *)getAudioPath
{
    NSString *strPath = [[FileManagerController libraryPath] stringByAppendingPathComponent:NOTE_MEDIA_PATH];
    strPath = [NSString stringWithFormat:@"%@/%@.m4a", strPath, [[NSDate date] qzgetDateTime]];
    if(![FileManagerController libraryCreateDirectoryPath:NOTE_MEDIA_PATH])
    {
        BBINFO(@"media file path create failed");
    }
    return strPath;
}


+ (NSString *)getVideoPath
{
    NSString *strPath = [[FileManagerController libraryPath] stringByAppendingPathComponent:NOTE_MEDIA_PATH];
    strPath = [NSString stringWithFormat:@"%@/%@.mov", strPath, [[NSDate date] qzgetDateTime]];
    if(![FileManagerController libraryCreateDirectoryPath:NOTE_MEDIA_PATH])
    {
        BBINFO(@"media file path create failed");
    }
    return strPath;
}
+ (NSString *)saveImageToSandBox:(UIImage *)image
{
    NSData *data;
    BOOL bPng = YES;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1);
        bPng = NO;
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    if(![FileManagerController libraryCreateDirectoryPath:NOTE_IMAGE_PATH])
    {
        BBINFO(@"file path create failed");
    }
    NSString *strPath = [self  getImagePathWithPng:bPng];
    BBINFO(@"file path is %@", strPath);
    [data writeToFile:strPath atomically:YES];
    return strPath;
}

+ (NSString *)saveVideoToSandBox:(NSData *)data
{
    NSString *strPath = [self getVideoPath];
    [data writeToFile:strPath atomically:YES];
    return strPath;
}

+ (NSString *)saveAudioToSandBox:(NSData *)data
{
    NSString *strPath = [self getAudioPath];
    [data writeToFile:strPath atomically:YES];
    return strPath;
}

+ (void)saveAudioToSandBox:(NSData *)data toPath:(NSString*)strPath
{
    [data writeToFile:strPath atomically:YES];
}

+ (BImage *)saveAssetImageToSand:(NSData *)bigData smlImag:(UIImage *)smlImage path:(NSString *)strPath isContent:(BOOL)bContent
{
    if(![FileManagerController fileExist:strPath])
    {
        if(![FileManagerController createDirectoryAtPath:strPath])
        {
            BBINFO(@"create new note fold falied;");
            assert(false);
        }
    }
    BOOL bret = YES;
    
    BImage *bimge = [[BImage alloc] init];
    bimge.create_date = [NSDate date];
    bimge.data_path = [NSString stringWithFormat:@"%@.jpg", bimge.key];
//    if(!bContent)
//    {
//        UIImage *squareImg = [smlImage imageAutoScale];
//        NSData *smlData =  UIImageJPEGRepresentation(squareImg, 1.0);
//        bimge.data_small_path = [NSString stringWithFormat:@"%@sml.jpg", bimge.key];
//        bret = [smlData writeToFile:[strPath stringByAppendingPathComponent:bimge.data_small_path] atomically:YES];
//        if(!bret)
//        {
//            BBINFO(@"%d, writeto file %@ failed", bret, bimge.data_small_path);
//        }
//    }
    bimge.size = [NSNumber numberWithLong:bigData.length];
    bimge.height = [NSNumber numberWithFloat:smlImage.size.height];
    bimge.width = [NSNumber numberWithFloat:smlImage.size.width];
    bimge.iscontent = [NSNumber numberWithBool:bContent];
    bimge.openupload = [NSNumber numberWithBool:YES];
    BBINFO(@"%f--%f", smlImage.size.width, smlImage.size.height);
    
    bret = [bigData writeToFile:[strPath stringByAppendingPathComponent:bimge.data_path] atomically:YES];
    

    if(!bret)
    {
        BBINFO(@"%d, writeto file %@ failed", bret, bimge.data_path);
    }
    return bimge;
}


+ (CGRect)getRect:(float)fX withPosY:(float)fY withwidth:(float)fW withHeight:(float)fH
{
    float fx = fX - fW * 0.5;
    return CGRectMake(fx, fY, fW, fH);
}

+(void)drawText:(BB_BBText *)content Incontext:(CGContextRef)context withRect:(CGRect)rct scale:(float)fScale
{
    NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
    CGContextSaveGState(context);
    
    if(!ISEMPTY(content.text_color))
    {
        CGContextSetFillColorWithColor(context, [content.text_color getColorFromString].CGColor);
    }
    else
    {
        CGContextSetFillColorWithColor(context, [[noteset strTextColor] getColorFromString].CGColor);
    }

    UIFont *txtFont = [UIFont systemFontOfSize:14 * fScale];
    
    
    if(!ISEMPTY(content.font) && ![content.font isEqualToString:@"system"] && content.fontsize && [content.fontsize integerValue] > 0)
    {
        txtFont = [UIFont fontWithName:content.font size:[content.fontsize integerValue] * fScale];;
    }
    else
    {
        txtFont = [UIFont systemFontOfSize:[content.fontsize integerValue] * fScale];
    }
    
    [content.text drawInRect:rct withFont:txtFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
    CGContextRestoreGState(context);
}

+(void)drawTitle:(BB_BBRecord *)record Incontext:(CGContextRef)context withRect:(CGRect)rct scale:(float)fScale
{
    int iWeekWidth_ = 120 * fScale;
    float iHeight = rct.size.height * 0.5;
    float iWidth = rct.size.width;
    //    float fR = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
    //    float fG = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
    //    float fB = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
    //    float fA = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:3] floatValue];
    //
    int iH = rct.size.height;
    CGContextSaveGState(context);
    //CGRect drawingRect = CGRectMake(0, 0, iWidth, self.frame.size.height);
    CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0.1, 1);
    CGContextSetRGBFillColor(context, 0.1, 0.1, 0, 0.6);
    //CGContextFillRect(context, drawingRect);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, SCR_WIDTH * fScale, 0);
    CGContextAddLineToPoint(context, SCR_WIDTH * fScale, iH);
    int iStep = 5 * fScale;
    int i = 1;
    while (SCR_WIDTH  * fScale - iStep * i > 0)
    {
        
        if(i % 2)
        {
            CGContextAddLineToPoint(context, SCR_WIDTH * fScale- iStep * i, iH - 3 * fScale);
        }
        else
        {
            CGContextAddLineToPoint(context, SCR_WIDTH * fScale - iStep * i, iH);
        }
        i ++;
    }
    CGContextAddLineToPoint(context, 0, iH);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    //bg
    int iLeftSapce = 8.0 * fScale;
    
    //    CGFloat fRadius = 5.0;
    //    CGContextMoveToPoint(context, fRadius, 0.0f);
    //    CGContextAddArc(context, iWidth - fRadius, fRadius, fRadius, -M_PI_2, 0.0f, 0);
    //    CGContextAddArc(context, iWidth - fRadius, self.frame.size.height - fRadius, fRadius, 0, M_PI_2, 0);
    //    CGContextAddArc(context, fRadius, self.frame.size.height - fRadius, fRadius, M_PI_2, M_PI, 0);
    //    CGContextAddArc(context, fRadius, fRadius, fRadius, M_PI, M_PI * 1.5, 0);
    //    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    CGContextMoveToPoint(context, iLeftSapce, iHeight);
    CGContextAddLineToPoint(context, iWeekWidth_ + iLeftSapce, iHeight);
    
    CGContextMoveToPoint(context, iLeftSapce + iWeekWidth_ / 2, iHeight);
    CGContextAddLineToPoint(context, iLeftSapce + iWeekWidth_ / 2, iHeight * 2);
    CGContextStrokePath(context);
    NSDate *date = record.create_date;
    NSString *strDate = [date getMonthDay];
    NSString *strTime = [date qzGetTime];
    NSString *strWeek = [date qzGetWeek];
//    NSString *strColor = record.title_color;
    int iMood = [record.mood integerValue];
    int iMoodCount = [record.mood_count integerValue];
    NSString *strMood = [NSString stringWithFormat:@"%.3i.png", iMood];
    
    UIFont *font = [UIFont systemFontOfSize:14 * fScale];
    CGRect dateRct = CGRectMake(iLeftSapce, 0, iWeekWidth_, iHeight);
    CGContextSetRGBFillColor(context, 0, 1, 0, 1);
    [strDate drawInRect:dateRct withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    CGRect weekRct = CGRectMake(iLeftSapce, iHeight, iWeekWidth_ / 2, iHeight);
    [strWeek drawInRect:weekRct withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    weekRct.origin.x = iLeftSapce + iWeekWidth_ / 2;
    [strTime drawInRect:weekRct withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    
    UIImage *img = [UIImage imageNamed:strMood];
    int iFaceWidth = 30 * fScale;
    int iImgTopSpace = (iHeight * 2 - iFaceWidth) / 2;
    
    [img drawInRect:CGRectMake(140 * fScale, iImgTopSpace, iFaceWidth, iFaceWidth) blendMode:kCGBlendModeNormal alpha:1.0];
    if(iMoodCount > 1)
        [img drawInRect:CGRectMake(180 * fScale, iImgTopSpace, iFaceWidth, iFaceWidth) blendMode:kCGBlendModeNormal alpha:1.0];
    if(iMoodCount > 2)
        [img drawInRect:CGRectMake(220 * fScale, iImgTopSpace, iFaceWidth, iFaceWidth) blendMode:kCGBlendModeNormal alpha:1.0];
    
    NSString *strVip = [NSString stringWithFormat:@"viplevel_%@.png", [[NSUserDefaults standardUserDefaults] objectForKey:@"vip"]];
    img = [UIImage imageNamed:strVip];
    [img drawInRect:CGRectMake(280 * fScale, iImgTopSpace, iFaceWidth, iFaceWidth) blendMode:kCGBlendModeNormal alpha:1.0];
    CGContextRestoreGState(context);
}

+ (UIImage *)createImageForBigWeibo:(BB_BBRecord *)record
{
    NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
    BB_BBText *bbcontent = record.contentInRecord;
    if(ISEMPTY(bbcontent.text))
    {
//        assert(false);
        bbcontent.text = @"blabla,你没有存进来东西...";
    }
    
    CGFloat contextScale = [[UIScreen mainScreen] scale];
    UIFont *txtFont = [UIFont systemFontOfSize:14 * contextScale];
    
    
    if(!ISEMPTY(bbcontent.font) && ![bbcontent.font isEqualToString:@"system"] && bbcontent.fontsize && [bbcontent.fontsize integerValue] > 0)
    {
        txtFont = [UIFont fontWithName:bbcontent.font size:[bbcontent.fontsize integerValue] * contextScale];;
    }
    else
    {
        txtFont = [UIFont systemFontOfSize:[bbcontent.fontsize integerValue] * contextScale];
    }
    
    int iTitleHeight = 40 * contextScale;
    float fSpace = 10.0f * contextScale;
    float fTextWidth = SCR_WIDTH * contextScale - fSpace * 2; //文字前后留宽10像素
    CGSize size = [bbcontent.text sizeWithFont:txtFont constrainedToSize:CGSizeMake(fTextWidth, 15000) lineBreakMode:NSLineBreakByTruncatingTail];
//    size = [bbcontent.text boundingRectWithSize:CGSizeMake(fTextWidth, 10000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: txtFont} context:nil].size;
    {
        size.height = size.height + [bbcontent.fontsize integerValue] * contextScale;
    }
    //计算文字高度
    BBINFO(@"bbcontent text %@ --size %@", bbcontent.text, NSStringFromCGSize(size));
    
    int iByteCount;
    int iBytesPerRow;
    int iWidth = SCR_WIDTH * contextScale;
    int iHight = SCR_HEIGHT * contextScale / 2;
    if(iHight - iTitleHeight - fSpace * 2 < size.height) //文字前后留宽10像素
        iHight = size.height + fSpace * 2 + iTitleHeight;
    iBytesPerRow  = iWidth * 4;
    iByteCount = iBytesPerRow * iHight;
    void *bitmapData = malloc(iByteCount);
    if(bitmapData == NULL)
    {
        NSLog(@"malloc bitmapdata space failed!");
        assert(false);
        return nil;
    }
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(bitmapData, iWidth, iHight, 8, iBytesPerRow, colorRef,  kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorRef);
    if(context == NULL)
    {
        NSLog(@"CGBitmapContextCreate failed!");
        assert(false);
        return nil;
    }
    UIGraphicsPushContext(context);
    CGContextTranslateCTM(context, 0, iHight);
    CGContextScaleCTM(context, 1, -1);
    UIImage *bgimg = nil;
    
 
    if(!ISEMPTY(record.bg_image))
    {
        BBINFO(@"-------- %@", record.bg_image);
        bgimg = [UIImage imageNamed:record.bg_image];
    }
    else
    {
        if(!ISEMPTY(record.bg_color))
        {
            CGContextSetFillColorWithColor(context, [record.bg_color getColorFromString].CGColor);
            
            //CGContextDrawPath(context, kCGPathFill);
            //CGContextFillPath(context);
        }
        else
        {
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        }
        CGContextFillRect(context, CGRectMake(0, 0, iWidth, iHight));
    }
    
    if(bgimg)
    {
        float fHeight = iHight;
        float fImgHeight = bgimg.size.height;
        
        float fTotal = 0;
        fImgHeight = fImgHeight * iWidth / bgimg.size.width;
        
        if(fImgHeight >= fHeight)
        {
            [bgimg drawInRect:CGRectMake(0, 0, iWidth, fImgHeight)];
        }
        else
        {
            while(fTotal < fHeight)
            {
                [bgimg drawInRect:CGRectMake(0, fTotal, iWidth, fImgHeight)];
                fTotal += fImgHeight;
                BBINFO(@"---- %f", fTotal);
            }
        }
    }
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldSmoothFonts(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);
    [self drawTitle:record Incontext:context withRect:CGRectMake(0, 0, iWidth, iTitleHeight) scale:contextScale];
    [self drawText:bbcontent Incontext:context withRect:CGRectMake(fSpace, fSpace + iTitleHeight, fTextWidth, iHight - iTitleHeight - fSpace * 2) scale:contextScale];
    
    {// test draw logo
        
        CGContextSetRGBFillColor(context, 1.0f, 0.0f, 0.0f, 0.1f);
        NSString *strLogo = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
        [strLogo drawInRect:CGRectMake((SCR_WIDTH -  110) * contextScale, iHight  - 20 * contextScale, 100 * contextScale, 20 * contextScale) withFont:[UIFont boldSystemFontOfSize:14 * contextScale]];
    }
    //CGContextDrawImage(context, CGRectZero, nil);
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    UIGraphicsPopContext();
    UIGraphicsEndImageContext();
    CGContextRelease(context);
    free(bitmapData);
    BBINFO(@"%@", NSStringFromCGSize(img.size));
    return img;
}

+ (UIImage *)createImageForRecord:(BRecord *)record
{
    return nil;
}

//delete image of coredata file
+ (void)deleteImageFileOfCoredata:(BImage *)bimg
{
    [FileManagerController removeFile:bimg.data_path];
//    [FileManagerController removeFile:bimg.data_small_path];
}
+ (void)deleteRecordFileOfCoredata:(BB_BBRecord *)brecord
{
    //    if(brecord.reserve1 && [brecord.reserve1 isEqualToString:@"YES"])
    //    {
    //
    //    }
    //    else
    //    {
    for (BB_BBImage *bbimg in [brecord.imageInRecord allObjects]) {
        [self deleteImageFileOfCoredata:bbimg];
    }
    
    //    }
}



+ (void)addToolBar:(NSString *)strTitle normalImg:(NSString *)strNormal hlImg:(NSString *)strHl rect:(CGRect)rct titleHeight:(float)fH inView:(UIView *)view withTag:(int)iTag action:(SEL)action target:(id )controler
{
    rct.origin.y = rct.origin.y;
    float fImgWidth = rct.size.height - fH;
    float fSpace = (rct.size.width - fImgWidth) / 2;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:strNormal] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:strHl] forState:UIControlStateHighlighted];
    [btn addTarget:controler action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:iTag];
    [btn setFrame:CGRectMake(rct.origin.x + fSpace, rct.origin.y, fImgWidth, fImgWidth)];
    [view addSubview:btn];
    
    rct.origin.y = rct.origin.y + fImgWidth - 2;
    rct.size.height = fH;
    UIFont *font = [UIFont systemFontOfSize:fH];
    UILabel *lbl = [[UILabel alloc] initWithFrame:rct];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:font];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl  setText:strTitle];
    [view addSubview:lbl];
}

+ (id)getANoNullObject:(id)aobject
{
    if(!aobject)
        return nil;
    if([aobject isEqual:[NSNull null]])
        return nil;
    return aobject;
    
}



+ (void)logSubviews:(UIView *)superview leve:(int)iLvl
{
    NSString *strPre = @"";
    for (int i = 0; i <= iLvl; i++) {
        strPre = [strPre stringByAppendingString:@"=="];
    }
    for (UIView *view in superview.subviews) {
        BBINFO(@"%@ -%@", strPre, view.debugDescription);
        [self logSubviews:view leve:iLvl + 1];
    }
}

+ (void)logSubViews:(UIView *)uiview
{
    NSLog(@"%@", uiview.debugDescription);
    [self logSubviews:uiview leve:0];
}

+ (CGPoint)getScreenBlowPointFrom:(CGRect)rct
{
    CGPoint retPoint = CGPointMake(0, 0);
    retPoint.x = SCR_WIDTH / 2;
    //    if(OS_VERSION  >= 7.0)
    retPoint.y = SCR_HEIGHT_P + rct.size.height / 2;
    //    else
    //        retPoint.y = SCR_HEIGHT + rct.size.height / 2;
    return retPoint;
}

+ (CGPoint)getScreenAbovePointFrom:(CGRect)rct
{
    CGPoint retPoint = CGPointMake(0, 0);
    retPoint.x = SCR_WIDTH / 2;
    //    if(OS_VERSION  >= 7.0)
    retPoint.y = SCR_HEIGHT_P - rct.size.height / 2;
    //    else
    //        retPoint.y = SCR_HEIGHT - rct.size.height / 2;
    return retPoint;
}



+ (CGPoint)getCurrentPointFrom:(CGRect)rct
{
    CGPoint pnt = CGPointMake(0, 0);
    pnt.x = rct.origin.x + rct.size.width / 2;
    pnt.y = rct.origin.y + rct.size.height / 2;
    return pnt;
}

+ (CGPoint)getBottomPointFrom:(CGRect)rct
{
    CGPoint pnt = CGPointMake(0, 0);
    pnt.x = rct.origin.x + rct.size.width / 2;
    //    if(OS_VERSION  >= 7.0)
    pnt.y = SCR_HEIGHT_P;
    //    else
    //        pnt.y = SCR_HEIGHT;
    pnt.y -= rct.size.height / 2;
    return pnt;
}


+ (CGRect)getScreenBlowRectForm:(CGRect)rct
{
    CGRect retRct = rct;
    //    if(OS_VERSION  >= 7.0)
    retRct.origin.y = SCR_HEIGHT_P;
    //    else
    //        retRct.origin.y = SCR_HEIGHT;
    return retRct;
}

+ (CGRect)getScreenAboveRectForm:(CGRect)rct
{
    CGRect retRct = rct;
    //    if(OS_VERSION  >= 7.0)
    retRct.origin.y = SCR_HEIGHT_P - rct.size.height;
    //    else
    //        retRct.origin.y = SCR_HEIGHT - rct.size.height;
    return retRct;
}


@end
