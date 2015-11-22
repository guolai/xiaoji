//
//  BBContent.h
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BB_BBText;

@interface BContent : NSObject<NSCoding>

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSDate * modify_date;
@property (nonatomic, strong) NSMutableArray *arrayLine;

- (instancetype)initWithBBText:(BB_BBText *)bbtext;
@end
