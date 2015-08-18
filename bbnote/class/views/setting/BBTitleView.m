//
//  BBTitleView.m
//  bbnote
//
//  Created by zhuhb on 13-5-25.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBTitleView.h"
#import "BB_BBAudio.h"
#import "BBPlayer.h"
#import "BBSkin.h"
#import "BBUserDefault.h"
#import "NSString+Help.h"
//#import "ShareWeibo.h"
#import "DataManager.h"



@implementation BBTitleView
@synthesize mulArray;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        iTopHeight_ = 24;
        iBtmHeight_ = 40;
        iMargin_ = 5;
        int iTopSpace = 4;
        int iTopTextHeight = 16;
        UIFont *font = [UIFont systemFontOfSize:10];
        imgviewLocation_ = [[UIImageView alloc] initWithFrame:CGRectMake(iMargin_, iTopSpace, iTopTextHeight, iTopTextHeight)];
        [imgviewLocation_ setImage:[UIImage imageNamed:@"browser_location.png"]];
        [self addSubview:imgviewLocation_];
        
        lblLocation_ = [[UILabel alloc] initWithFrame:CGRectMake(iMargin_ + iTopTextHeight + 2, iTopSpace, 160, iTopTextHeight)];
        [lblLocation_ setFont:font];
        [lblLocation_ setBackgroundColor:[UIColor clearColor]];
        [lblLocation_ setTextAlignment:NSTextAlignmentLeft];
        [lblLocation_ setTextColor:[UIColor whiteColor]];
        [lblLocation_ setLineBreakMode:NSLineBreakByTruncatingHead];
        [lblLocation_ setText:@"深圳市南山区沙河小学"];
        [self addSubview:lblLocation_];
        
        viewShareType_ = [[UIView alloc] initWithFrame:CGRectMake(SCR_WIDTH - iMargin_ - 130, iTopSpace, 90, iTopTextHeight)];
        [self addSubview:viewShareType_];
        
        imgviewAudio_ = [[UIImageView alloc] initWithFrame:CGRectMake(viewShareType_.frame.origin.x + viewShareType_.frame.size.width, iTopSpace, iTopTextHeight, iTopTextHeight)];
        [imgviewAudio_ setImage:[UIImage imageNamed:@"browser_audio.png"]];
        [self addSubview:imgviewAudio_];
        
        lblCount_ = [[UILabel alloc] initWithFrame:CGRectMake(SCR_WIDTH -iMargin_ - 40 + iTopTextHeight, iTopSpace, 20, iTopTextHeight)];
        [lblCount_ setFont:font];
        [lblCount_ setBackgroundColor:[UIColor clearColor]];
        [lblCount_ setTextAlignment:NSTextAlignmentCenter];
        [lblCount_ setTextColor:[UIColor whiteColor]];
        [lblCount_ setText:@"88"];
        [self addSubview:lblCount_];
        int iBtmSpace = 4;
        int iBtmTextHeight = 32;
        int iTop = iTopHeight_ + iBtmSpace;
        viewMood_ = [[UIView alloc] initWithFrame:CGRectMake(iMargin_, iTop, 104, iBtmTextHeight)];
        [self addSubview:viewMood_];
        
        lblOrder_ = [[UILabel alloc] initWithFrame:CGRectMake(SCR_WIDTH / 2 - 20, iTop, 40, iBtmTextHeight)];
        [lblOrder_ setText:@"8/88"];
        [lblOrder_ setBackgroundColor:[UIColor clearColor]];
        [lblOrder_ setTextColor:[UIColor whiteColor]];
        [lblOrder_ setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lblOrder_];
        
        UIImage *img = [UIImage imageNamed:@"browser_pause.png"];
        imgviewPlayState_ = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgviewPlayState_ setBackgroundImage:img forState:UIControlStateNormal];
        [imgviewPlayState_ addTarget:self action:@selector(playAudioPressed) forControlEvents:UIControlEventTouchUpInside];
        [imgviewPlayState_ setFrame:CGRectMake(SCR_WIDTH - iMargin_ - img.size.width, iTop, img.size.width, img.size.height)];
//        imgviewPlayState_ = [[UIImageView alloc] initWithFrame:CGRectMake(SCR_WIDTH - iMargin_ - img.size.width, iTop, img.size.width, img.size.height)];
//        [imgviewPlayState_ setImage:img];
        [self addSubview:imgviewPlayState_];
        
        lblTimes_ = [[UILabel alloc] initWithFrame:CGRectMake(imgviewPlayState_.frame.origin.x + 10, iTop, 60, img.size.height)];
        [lblTimes_ setTextAlignment:NSTextAlignmentLeft];
        [lblTimes_ setBackgroundColor:[UIColor clearColor]];
        [lblTimes_ setTextColor:[UIColor blackColor]];
        [lblTimes_ setText:@"88“"];
        [self addSubview:lblTimes_];
    }
    return self;
}

- (void)setrecord:(BB_BBRecord *)record
{

    NSString *strMood = [BB_BBRecord getRecordMoodStr:record];
    [self setMood:strMood andCount:[record.mood_count integerValue]];
    [self setLocation:record.location];
    [self setShareType:[record.shared_type unsignedIntegerValue]];
    self.mulArray = [record.audioInRecord allObjects];
    [self setAudioCount:self.mulArray.count];
    [self setPlayState:e_PlayState_Pause];
    if(self.mulArray.count > 0)
    {
        imgviewPlayState_.hidden = NO;
        lblTimes_.hidden = NO;
        BB_BBAudio *audio = [self.mulArray objectAtIndex:0];
        int iValue = [audio.times integerValue];
        [self setPlayTimes:iValue];
        [[BBPlayer ShareInstance] setPlayList:self.mulArray];
    }
    else
    {
        imgviewPlayState_.hidden = YES;
        lblTimes_.hidden = YES;
    }
}

- (void)setPlayTimes:(int)ivalue
{
    NSString *strTime = [NSString stringWithFormat:@"%d“", ivalue];
    [lblTimes_ setText:strTime];
}

- (void)setMood:(NSString *)strMood andCount:(int)icout
{
    [viewMood_.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float fWidth = viewMood_.frame.size.width;
    float fHeight = viewMood_.frame.size.height;
    if(icout == 1)
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((fWidth - fHeight) / 2, 0, fHeight, fHeight)];
        [img setImage:[UIImage imageNamed:strMood]];
        [viewMood_ addSubview:img];
        return;
    }
    if(icout == 2)
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(fWidth  / 2 - fHeight - 2, 0, fHeight, fHeight)];
        [img setImage:[UIImage imageNamed:strMood]];
        [viewMood_ addSubview:img];
        
        img = [[UIImageView alloc] initWithFrame:CGRectMake(fWidth  / 2 + 2, 0, fHeight, fHeight)];
        [img setImage:[UIImage imageNamed:strMood]];
        [viewMood_ addSubview:img];
        return;
    }
    for (int i = 0; i < icout; i++) {
        if(i >= 3)
            break;
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((fHeight + 4) * i, 0, fHeight, fHeight)];
        [img setImage:[UIImage imageNamed:strMood]];
        [viewMood_ addSubview:img];
    }
}

- (void)setpageOrder:(NSString *)strOrder
{
    lblOrder_.text = strOrder;
}

- (void)setPlayState:(T_PlayState)state
{
    if(state == e_PlayState_Pause)
    {
        [imgviewPlayState_ setImage:[UIImage imageNamed:@"browser_pause.png"] forState:UIControlStateNormal];
    }
    else
    {
        [imgviewPlayState_ setImage:[UIImage imageNamed:@"browser_playing.png"]  forState:UIControlStateNormal];
    }
}

- (void)setLocation:(NSString *)strLocation
{
    [lblLocation_ setText:strLocation];
}

- (void)setShareType:(unsigned int)type
{
    [viewShareType_.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int iSharecout = 0;
    if(type == 0)
        return;
    int iW = 16;
//    if(type & e_Share_Sina)
//    {
//        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (iW + 2) * iSharecout, iW)];
//        [img setImage:[UIImage imageNamed:@"sns_sinaweibo.png"]];
//        iSharecout ++;
//        [viewShareType_  addSubview:img];
//    }
//    if(type & e_Share_QQ)
//    {
//        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (iW + 2) * iSharecout, iW)];
//        [img setImage:[UIImage imageNamed:@"sns_qqzone.png"]];
//        iSharecout ++;
//        [viewShareType_  addSubview:img];
//    }
//    if(type & e_Share_WeiXin)
//    {
//        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (iW + 2) * iSharecout, iW)];
//        [img setImage:[UIImage imageNamed:@"sns_weixin.png"]];
//        iSharecout ++;
//        [viewShareType_  addSubview:img];
//    }
}

- (void)setAudioCount:(int)iCount
{
    [lblCount_ setText:[NSString stringWithFormat:@"%d", iCount]];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0.1, 0.1, 0.1, 0.5);
    CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0.1, 0.1);
    
    CGContextMoveToPoint(context, 0, 0);
    int iStep = 5;
    int i = 1;
    while (iStep * i < SCR_WIDTH) {
        if(i % 2)
        {
            CGContextAddLineToPoint(context, iStep * i, 0);
        }
        else
        {
            CGContextAddLineToPoint(context, iStep * i, 3);
        }
        i ++;
    }
    CGContextAddLineToPoint(context, SCR_WIDTH, 0);
    CGContextAddLineToPoint(context, SCR_WIDTH, iTopHeight_ + iBtmHeight_);
    CGContextAddLineToPoint(context, 0, iTopHeight_ + iBtmHeight_);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    CGColorSpaceRef colorSapceRef = CGColorSpaceCreateDeviceRGB();
    CGFloat linearcolors[] =
    {
        100.0 / 255.0, 100.0 / 255.0, 100.0 / 255.0, 0.50,
        79.0 / 255.0, 79.0 / 255.0, 79.0 / 255.0, 0.50,
        20.0 / 255.0,  20.0 / 255.0, 20.0 / 255.0, 0.50,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSapceRef, linearcolors, NULL, sizeof(linearcolors) / (sizeof(linearcolors[0]) * 4));
    CGColorSpaceRelease(colorSapceRef);
    CGPoint start = CGPointMake(0, iTopHeight_);
    CGPoint end = CGPointMake(0, iBtmHeight_ + iTopHeight_);
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    CGGradientRelease(gradient);
}

#pragma mark event
- (void)playAudioPressed
{
    if([[BBPlayer ShareInstance] playState] == AS_PLAYING)
    {
        [[BBPlayer ShareInstance] pausePlay];
        [self setPlayState:e_PlayState_Pause];
    }
    else
    {
        if([[BBPlayer ShareInstance] startPlay])
        {
            [self setPlayState:e_PlayState_Playing];
        }
    }
}

@end

@implementation FontTitleView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFontCellDidSelectedAColor object:nil];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        strText_ = [NSString stringWithFormat:@"微日记\n用声音、图片、视频记录生活中细微的感动!"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontColorChanged:) name:kFontCellDidSelectedAColor object:nil];
    }
    return self;
}


- (void)reloadFontViews
{
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect
{
    NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
    BBINFO(@"%@", NSStringFromCGRect(rect));
    CGContextRef context = UIGraphicsGetCurrentContext();

    if(noteset.isUseBgImg && noteset.strBgImg)
    {
        NSString *strBgImage = noteset.strBgImg;
        UIImage *img = [UIImage imageNamed:strBgImage];
        [img drawInRect:CGRectMake(0, 0, rect.size.width, img.size.height * rect.size.width / img.size.width)];
        CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0, 0.9);
        //CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.9);
        CGContextSetFillColorWithColor(context, [BBSkin shareSkin].bgColor.CGColor);
        int iHeight = rect.size.height;
        int iCha = 3;
        CGContextMoveToPoint(context, 0, iHeight);
        CGContextAddLineToPoint(context, rect.size.width, iHeight);
        CGContextAddLineToPoint(context, rect.size.width, iHeight - iCha);
        
        
        int iStep = 5;
        int i = 1;
        while (iStep * i < rect.size.width) {
            if(i % 2)
            {
                CGContextAddLineToPoint(context, rect.size.width - iStep * i, iHeight);
            }
            else
            {
                CGContextAddLineToPoint(context, rect.size.width - iStep * i, iHeight - iCha);
            }
            i ++;
        }
        CGContextAddLineToPoint(context, 0, rect.size.height);
 
        
        CGContextDrawPath(context, kCGPathFill);
    }
    else
    {
        
        CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0, 0.9);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, rect.size.width, 0);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
        int iHeight = rect.size.height;
        
        int iStep = 5;
        int i = 1;
        while (iStep * i < rect.size.width) {
            if(i % 2)
            {
                CGContextAddLineToPoint(context, rect.size.width - iStep * i, iHeight - 3);
            }
            else
            {
                CGContextAddLineToPoint(context, rect.size.width - iStep * i, iHeight);
            }
            i ++;
        }
        CGContextAddLineToPoint(context, 0, rect.size.height);
        NSString *strBgColor = noteset.strBgColor;
        CGContextSetFillColorWithColor(context, [strBgColor getColorFromString].CGColor);

        CGContextDrawPath(context, kCGPathFill);

    }
    
    NSString *strFontName = noteset.strFontName;
    int iSize = [[noteset nFontSize] integerValue];
    UIColor *color = [noteset.strTextColor getColorFromString];
    UIFont *font = [UIFont systemFontOfSize:iSize];
    if(strFontName && ![strFontName isEqualToString:@""] && ![strFontName isEqualToString:@"system"])
    {
        font = [UIFont fontWithName:strFontName size:iSize];
    }
    CGRect rct = CGRectMake(15, 15, rect.size.width  - 20*2, 60);
    CGContextSetFillColorWithColor(context, color.CGColor);
    [strText_ drawInRect:rct withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
  
}

#pragma mark --- notifacion

- (void)fontColorChanged:(NSNotification *)nt
{
    [self reloadFontViews];
}

@end

