//
//  DataModel.m
//  bbnote
//
//  Created by Apple on 13-5-20.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "DataModel.h"
#import "BB_BBImage.h"
#import "BB_BBAudio.h"
#import "BB_BBVideo.h"
#import "BB_BBContent.h"
#import "BContent.h"
#import "BRecord.h"
#import "Constant.h"
#import "FileManagerController.h"
#import <ImageIO/ImageIO.h>
#import "BBUserDefault.h"
#import "UIImage+SCaleImage.h"
#import "BStyle.h"

@implementation DataModel

+ (BOOL)deleteRecordByUUID:(NSString *)strUUid
{
    return YES;
}

+ (BB_BBRecord *)getRecordByUUid:(NSString *)strUUid
{
    BB_BBRecord *bbrecord = nil;
    NSArray *array = [BB_BBRecord where:[NSString stringWithFormat:@"user_id == '%@'", strUUid]];
    if(array && array.count > 0)
    {
        bbrecord = array.first;
    }
    return bbrecord;
}

+ (NSString *)getUUidFromRecord:(BB_BBRecord *)record
{
    return record.key;
}

+ (NSArray *)BBimageArrayGetImagelist:(NSArray *)array
{
    NSMutableArray *mularry = [NSMutableArray arrayWithCapacity:4];
    if(array && array.count > 0)
    {
        for (BB_BBImage *bbimage in array) {
            if(![bbimage.iscontent boolValue])
            {
                [mularry addObject:bbimage];
            }
        }
    }
    return mularry;
}



//+ (void)changeImageUploadStatus:(NSString *)key
//{
//    BBImage *bbimg = nil;
//    NSArray *array = [BBImage where:[NSString stringWithFormat:@"key == '%@'", key]];
//    if (array && array.count > 0) {
//        bbimg = array.first;
//    }
//    if(bbimg.update)
//    {
//        NSString *str = bbimg.update;
//        bbimg.update = [NSString stringWithFormat:@"%@,%@", str, KP_USER];
//    }
//    else
//        bbimg.update = KP_USER;
//    [bbimg save];
//}
//
//+ (void)changeAudioUploadStatus:(NSString *)key
//{
//    BBAudio *bbimg = nil;
//    NSArray *array = [BBAudio where:[NSString stringWithFormat:@"key == '%@'", key]];
//    if (array && array.count > 0) {
//        bbimg = array.first;
//    }
//    if(bbimg.update)
//    {
//        NSString *str = bbimg.update;
//        bbimg.update = [NSString stringWithFormat:@"%@,%@", str, KP_USER];
//    }
//    else
//        bbimg.update = KP_USER;
//    [bbimg save];
//}
//
//+ (void)changeVideoUploadStatus:(NSString *)key
//{
//    BBVideo *bbimg = nil;
//    NSArray *array = [BBVideo where:[NSString stringWithFormat:@"key == '%@'", key]];
//    if (array && array.count > 0) {
//        bbimg = array.first;
//    }
//    if(bbimg.update)
//    {
//        NSString *str = bbimg.update;
//        bbimg.update = [NSString stringWithFormat:@"%@,%@", str, KP_USER];
//    }
//    else
//        bbimg.update = KP_USER;
//    [bbimg save];
//}

+ (void)deleteBBimageFromKey:(NSString *)strKey
{
    BB_BBImage *bbimg = nil;
    NSArray *array = [BB_BBImage where:[NSString stringWithFormat:@"key == '%@'", strKey]];
    if (array && array.count > 0) {
        bbimg = array.first;
        [bbimg delete];
    }
}

+ (void)deleteBBAudioFromKey:(NSString *)strKey
{
    BB_BBAudio *bbimg = nil;
    NSArray *array = [BB_BBAudio where:[NSString stringWithFormat:@"key == '%@'", strKey]];
    if (array && array.count > 0) {
        bbimg = array.first;
        [bbimg delete];
    }
}

+ (void)deleteBBVideoFromKey:(NSString *)strKey
{
    BB_BBVideo *bbimg = nil;
    NSArray *array = [BB_BBVideo where:[NSString stringWithFormat:@"key == '%@'", strKey]];
    if (array && array.count > 0) {
        bbimg = array.first;
        [bbimg delete];
    }
}

+ (NSString *)getViewJPgFileFilePath
{
    NSString *strPath = [FileManagerController libraryPath];
    strPath = [strPath stringByAppendingPathComponent:@"view.jpg"];
    return strPath;
}
+ (NSString *)getNotePath:(id )bbrecord
{
    NSString *strFloder = [[FileManagerController libraryPath] stringByAppendingPathComponent:@"note"];
    if(![FileManagerController fileExist:strFloder])
    {
        [FileManagerController createDirectoryAtPath:strFloder];
    }
    if ([bbrecord isKindOfClass:[BB_BBRecord class]]) {
        strFloder = [strFloder stringByAppendingPathComponent:((BB_BBRecord *)bbrecord).key];
    }
    else if([bbrecord isKindOfClass:[BRecord class]])
    {
        strFloder = [strFloder stringByAppendingPathComponent:((BRecord *)bbrecord).key];
    }
    else
    {
        NSAssert(false, @"error happened!");
    }
    
    if(![FileManagerController fileExist:strFloder])
    {
        [FileManagerController createDirectoryAtPath:strFloder];
    }
    return strFloder;
}

+ (NSData *)dataWithCGImageRefImage:(CGImageRef)cgimgref exifInfo:(NSDictionary *)dic
{
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    UIImage *origiImage = nil;
    NSString *xmpString = [mulDic objectForKey:@"AdjustmentXMP"];
    if(OS_VERSION >= 7.0 && xmpString) //处理系统滤镜
    {
        NSData *xmpData = [xmpString dataUsingEncoding:NSUTF8StringEncoding];
        CIImage *image = [CIImage imageWithCGImage:cgimgref];
        
        NSError *error = nil;
        NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData
                                                     inputImageExtent:image.extent
                                                                error:&error];
        CIContext *context = [CIContext contextWithOptions:nil];
        if (filterArray && !error) {
            @autoreleasepool {
                for (CIFilter *filter in filterArray) {
                    [filter setValue:image forKey:kCIInputImageKey];
                    image = [filter outputImage];
                }
                cgimgref = [context createCGImage:image fromRect:[image extent]];
            }
        }
        [mulDic removeObjectForKey:@"AdjustmentXMP"];
    }
    if(mulDic)
    {
        origiImage = [UIImage imageWithCGImage:cgimgref scale:1.0 orientation:(UIImageOrientation)[mulDic objectForKey:(NSString *)kCGImagePropertyOrientation]];
    }
    else
    {
        origiImage = [UIImage imageWithCGImage:cgimgref];
    }
    return [self dataWithOrigiImage:origiImage exifInfo:mulDic];
}

+ (NSData *)dataWithOrigiImage:(UIImage *)origiImage exifInfo:(NSDictionary *)mulDic
{
    
    NSData *orginalData = UIImageJPEGRepresentation(origiImage, 0.9);
    NSMutableData *data1 = [NSMutableData data];
    if(mulDic)
    {
        CGImageSourceRef source =CGImageSourceCreateWithData((__bridge CFDataRef)orginalData, NULL);
        CFStringRef UTI = CGImageSourceGetType(source);
        
        CGImageDestinationRef destination =CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data1, UTI, 1,NULL);
        if(destination)
        {
            CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)mulDic);
            CGImageDestinationFinalize(destination);
        }
        CFRelease(destination);
        CFRelease(source);
        BBINFO(@"======================================= %@", mulDic);
    }
    return data1;
}

+ (NSDictionary *)getColorsTable
{
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strPlistPath];
    //NSLog(@"colors table %@", dic);
    return dic;
}

//for me copy data form librarypath
+ (void)copyMyOldNoteToDocument
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *strOldNotePath = [paths objectAtIndex:0];
    strOldNotePath = [NSString stringWithFormat:@"%@/note", strOldNotePath];
    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *strNewNotePath = [paths objectAtIndex:0];
    strNewNotePath = [NSString stringWithFormat:@"%@/note", strNewNotePath];
    [FileManagerController createDirectoryAtPath:strNewNotePath];
    [self scanFileInOldPath:strOldNotePath copytoNewPath:strNewNotePath];
}

+ (void)scanFileInOldPath:(NSString *)strOldNotePath copytoNewPath:(NSString *)strNewNotePath
{
    NSArray *allContentsPathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:strOldNotePath error:nil];
    for (NSString *strPath in allContentsPathArray) {
        NSString *fullPath = [strOldNotePath stringByAppendingPathComponent:strPath];
        NSString *newFullPath = [strNewNotePath stringByAppendingPathComponent:strPath];
        BOOL isDirectory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
        BBINFO(@"0000000 %@, isDirectory %d", fullPath, isDirectory);
        if(isDirectory)
        {
            [FileManagerController createDirectoryAtPath:newFullPath];
            [self scanFileInOldPath:fullPath copytoNewPath:newFullPath];
        }
        else
        {
            if([FileManagerController fileExist:newFullPath])
            {
                [FileManagerController removeFile:newFullPath];
            }
//            BBINFO(@"1111111 %@", fullPath);
//            BBINFO(@"2222222 %@", newFullPath);
            [FileManagerController copyItem:fullPath toItem:newFullPath];
        }
    }
    
}

+ (void)recoverCrashNote
{
    NSDictionary *noteDic = [BBUserDefault getArchiverDataOfNote];
    if(noteDic)
    {
       
        BB_BBRecord *bbRecord = nil;
        
        BRecord *bRecord =[NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"record"]];
        BContent *bContent = [NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"content"]];
        if(!bRecord || !bContent)
        {
            NSArray *array = [BB_BBRecord whereFormat:@"key == '%@'", bRecord.key];
            if(array && array.count > 0)
            {
                bbRecord = array.first;
                [bbRecord delete];
            }
            [BBUserDefault deleteArchvierDataNote];
            return;
            //            bContent = [[BContent alloc] init];
        }
        @try {
            bbRecord = [BB_BBRecord initWithBRecord:bRecord];
            
            BB_BBText *bbContent = [BB_BBText BBContentWithBContent:bContent];
            bbContent.record = bbRecord;

            NSArray *arrayAudio_ = [NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"audio"]];
            
            NSArray *arrayImage_ = [NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"image"]];
            if(!arrayImage_ || ![arrayImage_ isKindOfClass:[NSMutableArray class]])
            {
                arrayImage_ = [[NSMutableArray alloc] initWithCapacity:8];
            }
            NSArray *arrayVideo_ = [NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"video"]];
            for (BAudio *bAud in arrayAudio_)
            {
                BB_BBAudio *bbAudio = [BB_BBAudio BBAudioWithBAudio:bAud];
                bbAudio.record = bbRecord;
            }
            for (BImage *bimg in arrayImage_)
            {
                BB_BBImage *bbimage = [BB_BBImage BBImageWithBImage:bimg];
                bbimage.record = bbRecord;
            }
            for (BVideo *bvideo in arrayVideo_)
            {
                BB_BBVideo *bbvideo = [BB_BBVideo BBVideoWithBVideo:bvideo];
                bbvideo.record = bbRecord;
            }
            [bbRecord save];
        }
        @catch (NSException *exception)
        {
            [bbRecord delete];

        }
        @finally
        {
            [BBUserDefault deleteArchvierDataNote];
        }
        
    }
}

+ (ScaledBImage *)scaleImage:(UIImage *)oriImage
{
    if (!oriImage)
    {
        return nil;
    }
    CGFloat fWidth = SCR_WIDTH - fTextMargin * 2  - fImageMarin * [BBAutoSize screenScale];
    CGSize orisize = oriImage.size;
    CGSize displaySize = CGSizeZero;
    if(orisize.width > orisize.height)
    {
        if (orisize.width > orisize.height * 2)
        {
            displaySize = CGSizeMake(fWidth, fWidth / 2);
            oriImage = [oriImage clipImageToScaleSize:displaySize];
            orisize = displaySize;
        }
        else
        {
            displaySize = CGSizeMake(fWidth, fWidth * orisize.height / orisize.width);
        }
    }
    else
    {
        if (orisize.height > orisize.width * 2)
        {
            displaySize = CGSizeMake(fWidth, fWidth * 2);
            oriImage = [oriImage clipImageToScaleSize:displaySize];
            orisize = displaySize;
        }
        else
        {
            displaySize = CGSizeMake(fWidth, fWidth * orisize.height / orisize.width);
        }
    }
    ScaledBImage *scaleImage = [[ScaledBImage alloc] init];
    scaleImage.imge = oriImage;
    scaleImage.displaySize = displaySize;
    scaleImage.originalSize  = displaySize;
    return scaleImage;
}


+ (NSString *)checkFontName:(NSString *)strFontName2
{
    NSString *strFontName = @"STHeitiSC-Light";
    if (strFontName2 &&  ![strFontName2 isEqualToString:kDefatultFont])
    {
        strFontName = strFontName2;
    }
    return strFontName;
}

+ (NSString*)getRGBAStringFormColor:(UIColor *)color
{
    CGFloat  red, green, blue, alpha;
    [color getRed: &red green: &green blue:&blue alpha:&alpha];
    
    int iRed    = (int)(red*255);
    int iGreen  = (int)(green*255);
    int iBlue   = (int)(blue*255);
    return [NSString stringWithFormat:@"rgba(%d,%d,%d,%.1f)", iRed, iGreen, iBlue, alpha];
}

+ (BStyle *)getStyleFromDiction:(NSDictionary *)dic
{
    UIColor *forColor = [dic objectForKey:NSForegroundColorAttributeName];
    UIColor *bgColor = [dic objectForKey:NSBackgroundColorAttributeName];
    UIFont *font  = [dic objectForKey:NSFontAttributeName];
    
    BStyle *bstye = [[BStyle alloc] init];
    if (forColor && [forColor isKindOfClass:[UIColor class]])
    {
        bstye.strColor = [DataModel getRGBAStringFormColor:forColor];
    }
    if (bgColor && [bgColor isKindOfClass:[UIColor class]])
    {
        bstye.strBgColor = [DataModel getRGBAStringFormColor:bgColor];
    }
    if (font && [font isKindOfClass:[UIFont class]])
    {
        bstye.strFontName = font.familyName;
        bstye.strSize = [NSString stringWithFormat:@"%d", (int)font.pointSize];
    }
    return bstye;
}



@end
