//
//  AnimationHelper.h
//  Zine
//
//  Created by bob on 9/4/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AnimationHelper : NSObject
+ (CAAnimationGroup *)showInputAccessoryBarFromPoint:(CGPoint)beginPoint toPoint:(CGPoint)endPoint  duration:(float)fDuration;
+ (CAAnimationGroup *)dimissInputAccessoryBarFromPoint:(CGPoint)beginPoint toPoint:(CGPoint)endPoint duration:(float)fDuration;
+ (CAAnimationGroup *)hideInputAccessoryBarduration:(float)fDuration;
+ (CAAnimationGroup *)showPopViewFromPoint:(CGPoint)beginPoint toPoint:(CGPoint)endPoint;
+ (CAAnimationGroup *)hidePopview;
@end
