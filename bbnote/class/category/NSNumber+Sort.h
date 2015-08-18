//
//  NSNumber+Sort.h
//  bbnote
//
//  Created by Apple on 13-5-13.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BB_BBRecord.h"
#import "BB_BBImage.h"
#import "BB_BBAudio.h"

@interface NSNumber (Sort)
NSComparisonResult compareRecords(BB_BBRecord *firstRecrd, BB_BBRecord *secondRecrd, void *context);
NSComparisonResult compareImages(BB_BBImage *firstRecrd, BB_BBImage *secondRecrd, void *context);
NSComparisonResult compareAudios(BB_BBAudio *firstRecrd, BB_BBAudio *secondRecrd, void *context);
@end
