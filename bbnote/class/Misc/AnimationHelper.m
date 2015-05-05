//
//  AnimationHelper.m
//  Zine
//
//  Created by bob on 9/4/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import "AnimationHelper.h"

@implementation AnimationHelper

+ (CAAnimationGroup *)showInputAccessoryBarFromPoint:(CGPoint)beginPoint toPoint:(CGPoint)endPoint duration:(float)fDuration {
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    move.fromValue = [NSValue valueWithCGPoint:beginPoint];
    move.toValue = [NSValue valueWithCGPoint:endPoint];
    move.duration = fDuration;
    
//    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//    opacity.duration = fDuration;
//    opacity.values = @[@(0), @(1)];
//    opacity.calculationMode = kCAAnimationPaced;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[move/*,
                         opacity*/];
    group.duration = fDuration;
    //group.fillMode = kCAAnimationPaced;
    
    return group;
}

+ (CAAnimationGroup *)dimissInputAccessoryBarFromPoint:(CGPoint)beginPoint toPoint:(CGPoint)endPoint duration:(float)fDuration
{
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    move.fromValue = [NSValue valueWithCGPoint:beginPoint];
    move.toValue = [NSValue valueWithCGPoint:endPoint];
    move.duration = fDuration;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[move];
    group.duration = fDuration;
    return group;
}

+ (CAAnimationGroup *)hideInputAccessoryBarduration:(float)fDuration {
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacity.duration = fDuration;
    opacity.values = @[@(1), @(0)];
    opacity.calculationMode = kCAAnimationLinear;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[opacity];
    group.duration = fDuration;
    //group.fillMode = kCAFillModeForwards;
    
    return group;
}

+ (CAAnimationGroup *)showPopViewFromPoint:(CGPoint)beginPoint toPoint:(CGPoint)endPoint {
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    move.fromValue = [NSValue valueWithCGPoint:beginPoint];
    move.toValue = [NSValue valueWithCGPoint:endPoint];
    move.duration = .2f;
    
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacity.duration = .2f;
    opacity.values = @[@(0), @(1)];
    opacity.calculationMode = kCAAnimationLinear;
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.fromValue = [NSNumber numberWithFloat:0.6];
	scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
	scaleAnimation.duration = 0.2f;
	scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[move,
                         opacity, scaleAnimation];
    group.duration = .2f;
    group.fillMode = kCAFillModeForwards;
    
    return group;
}

+ (CAAnimationGroup *)hidePopview {
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacity.duration = .3f;
    opacity.values = @[@(1), @(0)];
    opacity.calculationMode = kCAAnimationLinear;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	scaleAnimation.toValue = [NSNumber numberWithFloat:0.3];
	scaleAnimation.duration = 0.2f;
	scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[opacity, scaleAnimation];
    group.duration = .3f;
    group.fillMode = kCAFillModeForwards;
    
    return group;
}

@end
