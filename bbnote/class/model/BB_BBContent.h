//
//  BBContent.h
//  bbnote
//
//  Created by bob on 13-8-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BB_BBRecord;
@class BContent;
@class BB_BBLine;

@interface BB_BBText : NSManagedObject

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSDate * modify_date;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) BB_BBRecord *record;
@property (nonatomic, retain) NSSet *lineInText;

- (void)updateWithBContent:(BContent *)bcontent;
+ (BB_BBText *)BBContentWithBContent:(BContent *)bContent;
//- (NSDictionary *)covertDictionary;
@end

@interface BB_BBText (CoreDataGeneratedAccessors)

- (void)addLineInRecordObject:(BB_BBLine *)value;
- (void)removeLineInRecordObject:(BB_BBLine *)value;
- (void)addLineInRecord:(NSSet *)values;
- (void)removeLineInRecord:(NSSet *)values;
@end