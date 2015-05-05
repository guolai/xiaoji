//
//  BBRecord.h
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class BBRecord;
@interface BRecord : NSObject<NSCoding>

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSNumber * mood;
@property (nonatomic, retain) NSNumber * mood_count;
@property (nonatomic, retain) NSNumber * isVideo;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * shared_type;
@property (nonatomic, retain) NSString * bg_image;
@property (nonatomic, retain) NSString * bg_color;
@property (nonatomic, retain) NSString * title_color;
@property (nonatomic, retain) NSString * bg_music;
@property (nonatomic, retain) NSNumber * isopen_music;
@property (nonatomic, retain) NSNumber * year_month;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * lookup;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, strong) NSNumber *isDemo;

- (instancetype)initWithBBrecord:(BBRecord *)bbrecord;
@end

