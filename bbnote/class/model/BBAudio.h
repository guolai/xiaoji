//
//  BBAudio.h
//  bbnote
//
//  Created by bob on 13-8-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBRecord;
@class BAudio;
@interface BBAudio : NSManagedObject

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * data_path;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * openupload;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * times;
@property (nonatomic, retain) NSString * update;
@property (nonatomic, retain) BBRecord *record;

+ (BBAudio *)BBAudioWithBAudio:(BAudio *)baudio;
- (NSDictionary *)covertDictionary;
@end
