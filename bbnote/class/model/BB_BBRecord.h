//
//  BBRecord.h
//  bbnote
//
//  Created by bob on 13-8-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BRecord, BContent;
@class BB_BBAudio, BB_BBText, BB_BBImage, BB_BBVideo;

@interface BB_BBRecord : NSManagedObject

@property (nonatomic, retain) NSString * bg_color;
@property (nonatomic, retain) NSString * bg_image;
@property (nonatomic, retain) NSString * bg_music;
@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSNumber * isopen_music;
@property (nonatomic, retain) NSNumber * isVideo;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * lookup;
@property (nonatomic, retain) NSNumber * mood;
@property (nonatomic, retain) NSNumber * mood_count;

@property (nonatomic, retain) NSNumber * shared_type;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * title_color;
@property (nonatomic, retain) NSNumber * year_month;
@property (nonatomic, strong) NSNumber * isDemo;
@property (nonatomic, retain) NSSet *audioInRecord;
@property (nonatomic, retain) BB_BBText *contentInRecord;
@property (nonatomic, retain) NSSet *imageInRecord;
@property (nonatomic, retain) NSSet *videoInRecord;

//+ (void)saveBBRecordWithBRecord:(BRecord *)brecord content:(BContent *)bContent imageArray:(NSArray *)imgArray audioArray:(NSArray *)audioArry videoArray:(NSArray *)videoArry;
+ (BB_BBRecord *)initWithBRecord:(BRecord *)brecord;
+ (NSString *)getRecordMoodStr:(BB_BBRecord *)recd;
- (NSDictionary *)covertDictionary;
- (void)saveToSandBoxPath:(NSString *)strFolder;

@end

@interface BB_BBRecord (CoreDataGeneratedAccessors)

- (void)addAudioInRecordObject:(BB_BBAudio *)value;
- (void)removeAudioInRecordObject:(BB_BBAudio *)value;
- (void)addAudioInRecord:(NSSet *)values;
- (void)removeAudioInRecord:(NSSet *)values;
- (void)addImageInRecordObject:(BB_BBImage *)value;
- (void)removeImageInRecordObject:(BB_BBImage *)value;
- (void)addImageInRecord:(NSSet *)values;
- (void)removeImageInRecord:(NSSet *)values;
- (void)addVideoInRecordObject:(BB_BBVideo *)value;
- (void)removeVideoInRecordObject:(BB_BBVideo *)value;
- (void)addVideoInRecord:(NSSet *)values;
- (void)removeVideoInRecord:(NSSet *)values;
@end
