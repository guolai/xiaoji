//
//  NSArray+Accessors.h
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Accessors)
@property(readonly) id first;
@property(readonly) id last;

- (void)each:(void (^)(id object))block;
- (void)eachWithIndex:(void (^)(id object, int index))block;

@end
