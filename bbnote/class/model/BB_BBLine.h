//
//  BB_BBLine.h
//  bbnote
//
//  Created by bob on 11/22/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BB_BBText;
@class BLine;
@interface BB_BBLine : NSManagedObject
@property (nullable, nonatomic, retain) NSNumber *line;
@property (nullable, nonatomic, retain) NSNumber *run;
@property (nullable, nonatomic, retain) NSNumber *location;
@property (nullable, nonatomic, retain) NSNumber *length;
@property (nullable, nonatomic, retain) NSString *fontname;
@property (nullable, nonatomic, retain) NSString *fontsize;
@property (nullable, nonatomic, retain) NSString *forcolor;
@property (nullable, nonatomic, retain) NSString *bgcolor;
@property (nullable, nonatomic, retain) NSString *text;

//img
@property (nullable, nonatomic, retain) NSString *fileName;
@property (nullable, nonatomic, retain) NSNumber *displaySizeW;
@property (nullable, nonatomic, retain) NSNumber *displaySizeH;
@property (nullable, nonatomic, retain) NSNumber *orgiSizeW;
@property (nullable, nonatomic, retain) NSNumber *orgiSizeH;
@property (nullable, nonatomic, retain) BB_BBText *bText;

+ (BB_BBLine * _Nonnull)BBLineCreateWithBContent:(BLine * _Nonnull)bline;
//- (NSDictionary * _Nonnull)covertDictionary;
@end
