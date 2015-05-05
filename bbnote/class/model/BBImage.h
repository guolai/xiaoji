//
//  BBImage.h
//  bbnote
//
//  Created by bob on 13-8-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBRecord;
@class BImage;
@interface BBImage : NSManagedObject

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * data_path;
@property (nonatomic, retain) NSString * data_small_path;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * iscontent;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * openupload;
@property (nonatomic, retain) NSString * reserve;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * update;
@property (nonatomic, retain) NSNumber * vertical;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) BBRecord *record;

+(BBImage *)BBImageWithBImage:(BImage *)bimg;
- (NSDictionary *)covertDictionary;
@end
