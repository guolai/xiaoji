//
//  DataManager.h
//  jyy
//
//  Created by bob on 3/22/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteSetting.h"
@interface DataManager : NSObject
@property (nonatomic, strong) NoteSetting *noteSetting;
@property (nonatomic, strong) NSString *strName;
@property (nonatomic, assign) int iTime;
+ (id)ShareInstance;
- (void)registerLocalAlert:(int)iValue;
- (void)removeLoaclNotification;

- (void)openAlert;
- (void)closeALert;
- (void)saveNoteSetting;

@end
