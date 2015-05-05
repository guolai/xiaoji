//
//  KPUser.h
//  bbnote
//
//  Created by Apple on 13-6-6.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPUser : NSObject<NSCoding>

@property(nonatomic, retain) NSNumber  * userID;
@property(nonatomic, retain) NSString  * userName;
@property(nonatomic, retain) NSNumber  * maxFileSize;
@property(nonatomic, retain) NSNumber  * quotaTotal;
@property(nonatomic, retain) NSNumber  * quotaUsed;

@end
