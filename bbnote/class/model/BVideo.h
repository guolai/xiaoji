//
//  BBVideo.h
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class BBVideo;
@interface BVideo : NSObject<NSCoding>

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * data_path;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * times;
@property (nonatomic, retain) NSString * update;
@property (nonatomic, retain) NSNumber * openupload;
@property (nonatomic, strong) NSString * key;
- (instancetype)initWithBBVideo:(BBVideo *)bbvideo;
@end
