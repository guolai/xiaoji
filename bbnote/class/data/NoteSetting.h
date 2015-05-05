//
//  NoteSetting.h
//  bbnotes
//
//  Created by bob on 6/3/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteSetting : NSObject<NSCoding>
@property (nonatomic, assign) BOOL isUseBgImg; //这个字段会不会和下面的字段重复了呢
@property (nonatomic, strong) NSString *strBgImg;
@property (nonatomic, strong) NSString *strBgColor;
@property (nonatomic, strong) NSString *strTextColor;
@property (nonatomic, strong) NSString *strFontName;
@property (nonatomic, strong) NSNumber *nFontSize;
@end
