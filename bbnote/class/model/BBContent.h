//
//  BBContent.h
//  bbnote
//
//  Created by bob on 13-8-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBRecord;
@class BContent;
//@interface BBContent : NSManagedObject
//
//@property (nonatomic, retain) NSDate * create_date;
//@property (nonatomic, retain) NSString * font;
//@property (nonatomic, retain) NSNumber * fontsize;
//@property (nonatomic, retain) NSDate * modify_date;
//@property (nonatomic, retain) NSString * reserve;
//@property (nonatomic, retain) NSString * text;
//@property (nonatomic, retain) NSString * text_color;
//@property (nonatomic, retain) BBRecord *record;
//
//
//+ (BBContent *)BBContentWithBContent:(BContent *)bContent;
//@end

@interface BBText : NSManagedObject

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * font;
@property (nonatomic, retain) NSNumber * fontsize;
@property (nonatomic, retain) NSDate * modify_date;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * text_color;
@property (nonatomic, retain) BBRecord *record;

- (void)updateWithBContent:(BContent *)bcontent;
+ (BBText *)BBContentWithBContent:(BContent *)bContent;
- (NSDictionary *)covertDictionary;
@end