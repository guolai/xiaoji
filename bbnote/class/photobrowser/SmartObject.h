//
//  SmartObject.h
//  bbnotes
//
//  Created by bob on 7/28/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartObject : NSObject
@property (nonatomic, strong) NSString *strNotePath;
@property (nonatomic, strong) NSString *strFileName;
@property (nonatomic, strong) NSString *strSmlFileName;
@property (nonatomic, strong) NSString *strServerId;
@property (nonatomic, strong) NSNumber *numOrder;
@property (nonatomic, strong) NSNumber *numDate;
@end
