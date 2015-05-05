//
//  DataModel.h
//  bbnote
//
//  Created by Apple on 13-5-20.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBRecord.h"


@interface DataModel : NSObject

+ (BOOL)deleteRecordByUUID:(NSString *)strUUid;

+ (BBRecord *)getRecordByUUid:(NSString *)strUUid;

+ (NSString *)getUUidFromRecord:(BBRecord *)record;

+ (NSArray *)BBimageArrayGetImagelist:(NSArray *)array;

//+ (void)changeImageUploadStatus:(NSString *)key;
//
//+ (void)changeAudioUploadStatus:(NSString *)key;
//
//+ (void)changeVideoUploadStatus:(NSString *)key;

+ (void)deleteBBimageFromKey:(NSString *)strKey;
+ (void)deleteBBAudioFromKey:(NSString *)strKey;
+ (void)deleteBBVideoFromKey:(NSString *)strKey;
+ (NSString *)getViewJPgFileFilePath;
+ (NSString *)getNotePath:(id )bbrecord;
+ (NSData *)dataWithCGImageRefImage:(CGImageRef)cgimgref exifInfo:(NSDictionary *)dic;
+ (NSData *)dataWithOrigiImage:(UIImage *)imge exifInfo:(NSDictionary *)dic;
+ (NSDictionary *)getColorsTable;

//for me copy data form librarypath
+ (void)copyMyOldNoteToDocument;

+ (void)recoverCrashNote;
@end
