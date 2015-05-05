//
//  BBDateView.m
//  bbnote
//
//  Created by Apple on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBDateView.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Help.h"
#import "NSDate+String.h"

@implementation BBDateView
@synthesize strDate;
@synthesize strTime;
@synthesize strWeek;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    BBLOG();
    self = [super initWithFrame:frame];
    if (self) {
        BBLOG();
        [self setBackgroundColor:[UIColor clearColor]];
        iMoodCount_ = 1;
        iWeekWidth_ = 120;
        UIButton *btnDate = [UIButton buttonWithType:UIButtonTypeCustom];
        //[btnDate setTitle:@"adf" forState:UIControlStateNormal];
        //[btnDate setOpaque:YES];
        [btnDate setFrame:CGRectMake(0, 0, 200, frame.size.height)];
        [btnDate addTarget:self action:@selector(changeDatePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDate];
        
        
        NSString *strBiaoqing = @"001.png";
       btnMood_ = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMood_ setImage:[UIImage imageNamed:strBiaoqing] forState:UIControlStateNormal];
        //[btnMood setImage:[UIImage imageNamed:strBiaoqing] forState:UIControlStateHighlighted];
        //[btnMood setAlpha:0];
        [btnMood_ setFrame:CGRectMake(iWeekWidth_ + 20, 0, 40, frame.size.height)];
        [btnMood_ addTarget:self action:@selector(changeMoodPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnMood_];
        
        int iFaceWidth = 32;
        int iImgTopSpace = (self.frame.size.height - iFaceWidth) / 2;
        imgView1_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:strBiaoqing]];
        [imgView1_ setFrame:CGRectMake(iWeekWidth_ + 20 + 40, iImgTopSpace, iFaceWidth, iFaceWidth)];
        [imgView1_ setHidden:YES];
        [self addSubview:imgView1_];
        imgView2_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:strBiaoqing]];
        [imgView2_ setFrame:CGRectMake(iWeekWidth_ + 20 + 80, iImgTopSpace, iFaceWidth, iFaceWidth)];
        [imgView2_ setHidden:YES];
        [self addSubview:imgView2_];
        
        UIPanGestureRecognizer *tapGst = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestrue:)];
        tapGst.minimumNumberOfTouches = 1;
        tapGst.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:tapGst];
        
        strVip_ = [NSString stringWithFormat:@"viplevel_%@.png", [[NSUserDefaults standardUserDefaults] objectForKey:@"vip"]];
    }
    return self;
}

- (void)setDate:(NSDate *)date withColor:(NSString *)strcolor andMood:(NSNumber *)mood
{
    self.strDate = [date qzGetDate];
    self.strTime = [date qzGetTime];
    self.strWeek = [date qzGetWeek];
    self.strColor = strcolor;
    [self changeMood:mood];
    [self setNeedsDisplay];
}

- (int)getMoodCount
{
    return iMoodCount_;
}

- (void)changeMood:(NSNumber *)mood
{
    self.strMood = [NSString stringWithFormat:@"%.3i.png",[mood integerValue]];
    if([mood integerValue] <= 0)
    {
        self.strMood = @"001.png";
  
    }
    [imgView1_ setImage:[UIImage imageNamed:self.strMood]];
    [imgView2_ setImage:[UIImage imageNamed:self.strMood]];
    [btnMood_ setImage:[UIImage imageNamed:self.strMood] forState:UIControlStateNormal];
    [self changeMoodCount:1];
}

- (void)changeMoodCount:(int)iCount
{
    if(iCount < 1 || iCount > 3)
        return;
    //if(iMoodCount_ != iCount)
    {

        if(iCount == 2 && iMoodCount_ < iCount)
        {
            imgView1_.hidden = NO;
            CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            [basic setDuration:0.6];
            [basic setRepeatCount:1.0];
            [basic setAutoreverses:NO];
            
//            NSValue *valueForm = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//            CATransform3D transTo = CATransform3DMakeScale(2.5, 2.5, 0.3);
//            NSValue *valueTo = [NSValue valueWithCATransform3D:transTo];
//            
//            [basic setFromValue:valueForm];
//            [basic setToValue:valueTo];
            [basic setFromValue:[NSNumber numberWithFloat:2.0]];
            [basic setToValue:[NSNumber numberWithFloat:1.0]];
            
            [imgView1_.layer addAnimation:basic forKey:@"imgview1"];
        }
        else if(iCount == 3 && iMoodCount_ < iCount)
        {
            imgView2_.hidden = NO;
            CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            [basic setDuration:0.6];
            [basic setRepeatCount:1.0];
            [basic setAutoreverses:NO];
            
//            NSValue *valueForm = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//            CATransform3D transTo = CATransform3DMakeScale(2.5, 2.5, 0.3);
//            NSValue *valueTo = [NSValue valueWithCATransform3D:transTo];
            
            [basic setFromValue:[NSNumber numberWithFloat:3.0]];
            [basic setToValue:[NSNumber numberWithFloat:1.0]];
            [imgView2_.layer addAnimation:basic forKey:@"imgview1"];
        }
        else if(iCount == 2 && iMoodCount_ > iCount)
        {
//            [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
//                CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//                scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//                scaleAnimation.toValue = [NSNumber numberWithFloat:0.1];
//                scaleAnimation.duration = 1.5;
//                scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                [imgView2_.layer addAnimation:scaleAnimation forKey:@"imgview1"];
//            } completion:^(BOOL finished){
//                imgView2_.hidden  = YES;
//            }];
            imgView2_.hidden = YES;
        }
        else if(iCount == 1 && iMoodCount_ > iCount)
        {
//            [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
//                CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//                scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//                scaleAnimation.toValue = [NSNumber numberWithFloat:0.1];
//                scaleAnimation.duration = 1.5;
//                scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                [imgView1_.layer addAnimation:scaleAnimation forKey:@"imgview1"];
//            } completion:^(BOOL finished){
//                imgView1_.hidden  = YES;
//            }];
            imgView1_.hidden = YES;
        }
        else
        {
            
        }
        iMoodCount_ = iCount;
    }
}

#pragma mark --- draw
- (void)drawRect:(CGRect)rect
{
    BBLOG();
    float iHeight = self.frame.size.height * 0.5;
    float iWidth = self.frame.size.width;
    CGContextRef context = UIGraphicsGetCurrentContext();
//    float fR = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
//    float fG = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
//    float fB = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
//    float fA = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:3] floatValue];
//    
    int iH = self.frame.size.height;
    //CGRect drawingRect = CGRectMake(0, 0, iWidth, self.frame.size.height);
    CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0.1, 1);
    CGContextSetRGBFillColor(context, 0.1, 0.1, 0, 0.6);
    //CGContextFillRect(context, drawingRect);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, SCR_WIDTH, 0);
    CGContextAddLineToPoint(context, SCR_WIDTH, iH);
    int iStep = 5;
    int i = 1;
    while (SCR_WIDTH - iStep * i > 0)
    {

        if(i % 2)
        {
            CGContextAddLineToPoint(context, SCR_WIDTH - iStep * i, iH - 3);
        }
        else
        {
            CGContextAddLineToPoint(context, SCR_WIDTH - iStep * i, iH);
        }
        i ++;
    }
    CGContextAddLineToPoint(context, 0, iH);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    //bg
    int iLeftSapce = 8.0;
    
//    CGFloat fRadius = 5.0;
//    CGContextMoveToPoint(context, fRadius, 0.0f);
//    CGContextAddArc(context, iWidth - fRadius, fRadius, fRadius, -M_PI_2, 0.0f, 0);
//    CGContextAddArc(context, iWidth - fRadius, self.frame.size.height - fRadius, fRadius, 0, M_PI_2, 0);
//    CGContextAddArc(context, fRadius, self.frame.size.height - fRadius, fRadius, M_PI_2, M_PI, 0);
//    CGContextAddArc(context, fRadius, fRadius, fRadius, M_PI, M_PI * 1.5, 0);
//    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    CGContextMoveToPoint(context, iLeftSapce, iHeight);
    CGContextAddLineToPoint(context, iWeekWidth_ + iLeftSapce, iHeight);
    
    CGContextMoveToPoint(context, iLeftSapce + iWeekWidth_ / 2, iHeight);
    CGContextAddLineToPoint(context, iLeftSapce + iWeekWidth_ / 2, iHeight * 2);
    CGContextStrokePath(context);
    
    UIFont *font = [UIFont systemFontOfSize:14];
    CGRect dateRct = CGRectMake(iLeftSapce, 0, iWeekWidth_, iHeight);
    CGContextSetRGBFillColor(context, 0, 1, 0, 1);
    [self.strDate drawInRect:dateRct withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    CGRect weekRct = CGRectMake(iLeftSapce, iHeight, iWeekWidth_ / 2, iHeight);
    [self.strWeek drawInRect:weekRct withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    weekRct.origin.x = iLeftSapce + iWeekWidth_ / 2;
    [self.strTime drawInRect:weekRct withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];

    //UIImage *img = [UIImage imageNamed:self.strMood];
    int iFaceWidth = 30;
    int iImgTopSpace = (iHeight * 2 - iFaceWidth) / 2;
    //[img drawInRect:CGRectMake(140, iImgTopSpace, iFaceWidth, iFaceWidth) blendMode:kCGBlendModeNormal alpha:1.0];
    //[img drawInRect:CGRectMake(180, iImgTopSpace, iFaceWidth, iFaceWidth) blendMode:kCGBlendModeNormal alpha:1.0];
    //[img drawInRect:CGRectMake(220, iImgTopSpace, iFaceWidth, iFaceWidth) blendMode:kCGBlendModeNormal alpha:1.0];
 
    UIImage *img = [UIImage imageNamed:strVip_];
    [img drawInRect:CGRectMake(280, iImgTopSpace, iFaceWidth, iFaceWidth) blendMode:kCGBlendModeNormal alpha:1.0];
//    int iConeRadius = 18;
//    int iRightSpace = 10;
//    CGContextMoveToPoint(context, SCR_WIDTH - iConeRadius * 2 - iRightSpace, 8);
//    
    
}


#pragma mark ---event

- (void)handlePanGestrue:(UIPanGestureRecognizer *)sender
{
    CGPoint touchPng = [sender locationInView:self];
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        priPnt_ = touchPng;
    }
    else if(sender.state == UIGestureRecognizerStateChanged)
    {
        
    }
    else if(sender.state == UIGestureRecognizerStateEnded)
    {
        float fChax = touchPng.x - priPnt_.x;
        float fChay = touchPng.y - priPnt_.y;
        float fMax = MAX(fabs(fChax), fabs(fChay));
        if(fMax < 10)
            return;
        if(fabs(fChax) > fabs(fChay))
        {
            if(fChax > 0)
            {
                [self changeMoodCount:iMoodCount_ + 1];
                BBINFO(@"right");
            }
            else
            {
                [self changeMoodCount:iMoodCount_ - 1];
                BBINFO(@"left");
            }
        }
//        else
//        {
//            if(fChay > 0)
//            {
//
//                BBINFO(@"down");
//            }
//            else
//            {
//
//                BBINFO(@"up");
//            }
//        }
    }
    else
    {
        priPnt_.x = self.center.x;
        priPnt_.y = self.center.y;
    }
}

- (void)changeDatePressed:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(changeDateTime)])
    {
        [self.delegate changeDateTime];
    }
}

- (void)changeMoodPressed:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(changeMood)])
    {
        [self.delegate changeMood];
    }
}

//- (void)changMoodCountPressed:(id)sender
//{
//    if(self.delegate && [self.delegate respondsToSelector:@selector(changMoodCount)])
//    {
//        [self.delegate changMoodCount];
//    }
//}

@end
