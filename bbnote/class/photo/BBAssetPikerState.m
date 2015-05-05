//
//  BBAssetPikerState.m
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBAssetPikerState.h"

@implementation BBAssetPikerState


@synthesize state = _state;
@synthesize type;
@synthesize strValue;


- (id)init
{
    if(self = [super init])
    {
        self.state = BBAssetPikerStateInitializing;
        self.type = BBAssetPikerMask;
    }
    return self;
}


- (void)setState:(BBAssetPikingState)state
{
    _state = state;
}
@end
