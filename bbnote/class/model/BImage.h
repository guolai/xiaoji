//
//  BBImage.h
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BB_BBImage;
@interface BImage : NSObject<NSCoding>

@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * data_path;
@property (nonatomic, retain) NSString * data_small_path;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber *width;
@property (nonatomic, retain) NSNumber *vertical;
@property (nonatomic, retain) NSString * assetPath;
@property (nonatomic, retain) NSNumber * iscontent;
@property (nonatomic, retain) NSString * update;
@property (nonatomic, retain) NSNumber * openupload;
@property (nonatomic, strong) NSString * key;

- (instancetype)initWithBBImage:(BB_BBImage *)bbimage;
@end

@interface ScaledBImage : NSObject
@property (nonatomic, strong) UIImage *imge;
@property (nonatomic, assign) CGSize originalSize;
@property (nonatomic, assign) CGSize displaySize;
@end


