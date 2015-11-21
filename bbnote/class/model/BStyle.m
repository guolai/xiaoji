//
//  BStyle.m
//  bbnote
//
//  Created by bob on 10/8/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import "BStyle.h"

@implementation BStyle

- (instancetype)init
{
    if (self = [super init])
    {
        self.strBgColor = @"rgba(255,255,255,0.0)";
        self.strColor = @"rgba(0,0,0,1.0)";
        self.strFontName = kDefatultFont;
        self.strSize = @"12";
    }
    return self;
}

@end
