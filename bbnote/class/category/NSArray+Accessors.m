//
//  NSArray+Accessors.m
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "NSArray+Accessors.h"

@implementation NSArray (Accessors)
@dynamic first, last;

- (id)first {
    return [self objectAtIndex:0];
}

- (id)last {
    return [self lastObject];
}

- (void)each:(void (^)(id object))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (void)eachWithIndex:(void (^)(id object, int index))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}
@end
