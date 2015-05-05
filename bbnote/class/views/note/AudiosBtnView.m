//
//  AudiosBtnView.m
//  bbnote
//
//  Created by Apple on 13-4-9.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "AudiosBtnView.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+SCaleImage.h"
#import "BBSkin.h"
@interface AudiosBtnView ()


@end

@implementation AudiosBtnView
@synthesize baudio = _baudio;
@synthesize delegate;

- (id)initWithBAudio:(BAudio *)baudio
{
    self = [super init];
    if(self)
    {
        //    /*
        //     <10    40pix
        //     30sec 1/2
        //     5 min 1
        //     */
        iHeight_ = 36;
        iAudioWidth_ = 30;
        iPlayMixW_ = 40;
        iSapce_ = 25;
        iMaxWidth_ = (SCR_WIDTH - 30 * 2) - iAudioWidth_ - iSapce_ - iPlayMixW_;
        self.baudio = baudio;
        int iW = iPlayMixW_;
        if (_baudio)
        {
    
            float fTime = [_baudio.times floatValue];
            BBINFO(@"%f", fTime);
            if(fTime < 10)
            {
                
            }
            else if(fTime < 30)
            {
                iW += ((fTime - 10) / 20 * iMaxWidth_ * 0.5);
            }
            else if(fTime < 5 * 60)
            {
                iW += (iMaxWidth_ * 0.5);
                iW += ((fTime - 30 - 10) / 260 * iMaxWidth_ * 0.5);
            }
            else
                iW += iMaxWidth_;
        }
        [self setFrame:CGRectMake(30, 0, iAudioWidth_ + iSapce_ + iW, iHeight_)];
        self.userInteractionEnabled  = YES;
        BBLOG();

//        self.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] CGColor];
//        self.layer.borderWidth = 2.0f;
//        self.layer.shadowColor = [UIColor colorWithRed:198/255.0 green:126/255.0 blue:151/255.0 alpha:1.0].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0, 0);
//        self.layer.shadowOpacity = 0.8;
//        self.layer.shadowRadius = 2;
        [self setImage:[[UIImage imageNamed:@"audio_play.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10]];
  
        btnPlay_ = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPlay_ setImage:[UIImage imageNamed:@"audio_play_btn.png"] forState:UIControlStateNormal];
        [btnPlay_ setFrame:CGRectMake(0, (iHeight_ - iAudioWidth_) / 2, iAudioWidth_, iAudioWidth_)];
        [btnPlay_ addTarget:self action:@selector(audioPlayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnPlay_];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(iAudioWidth_, (iHeight_ - 15) / 2, iSapce_, 15)];
        [lbl  setBackgroundColor:[UIColor clearColor]];
        [lbl setTextColor:[BBSkin shareSkin].titleColor];
        int iTimes = [_baudio.times floatValue];
        [lbl setText:[NSString stringWithFormat:@"%d“", iTimes]];
        [self addSubview:lbl];
        
        UIImage *voiceImg = [UIImage imageNamed:@"voicefeeds_wave0.png"];
        animiteImgView_ = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - voiceImg.size.width - 10, (iHeight_ - voiceImg.size.height) / 2, voiceImg.size.width, voiceImg.size.height)];
        [animiteImgView_ setImage:[UIImage imageNamed:@"voicefeeds_wave0.png"]];
        [self addSubview:animiteImgView_];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setFrame:CGRectMake(self.frame.size.width - 40, 0, iPlayMixW_, iPlayMixW_)];
        [delBtn setOpaque:NO];
        [delBtn addTarget:self action:@selector(deleteAudio:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delBtn];
        NSMutableArray *mulArray = [NSMutableArray arrayWithCapacity:4];
        for(int i = 0; i < 4; i ++)
        {
            NSString *strFile = [NSString stringWithFormat:@"voicefeeds_wave%d.png", i];
            [mulArray addObject:[UIImage imageNamed:strFile]];
        }
        animiteImgView_.animationImages = mulArray;
        animiteImgView_.animationDuration = 1.0;
        animiteImgView_.animationRepeatCount = 10000;
        
    }
    return self;
}

- (void)setBaudio:(BAudio *)baudio  
{
    if(_baudio != baudio)
    {
        _baudio = baudio;
    }
}

- (NSString *)getAudioPath
{
    return _baudio.data_path;
}



- (void)startAnimition
{
    [btnPlay_ setImage:[UIImage imageNamed:@"audio_play_btn_hl.png"] forState:UIControlStateNormal];
    [btnPlay_ setEnabled:NO];

    [animiteImgView_ startAnimating];
}
- (void)stopAnimition
{
    [btnPlay_ setImage:[UIImage imageNamed:@"audio_play_btn.png"] forState:UIControlStateNormal];
    [btnPlay_ setEnabled:YES];
    [animiteImgView_ stopAnimating];
}

//- (void)drawRect:(CGRect)rect
//{
//    BBLOG();
//    float iWidth = self.frame.size.width;
//    CGContextRef context = UIGraphicsGetCurrentContext();
////    float fR = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
////    float fG = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
////    float fB = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue];
////    float fA = [[[self.strColor componentsSeparatedByString:@","] objectAtIndex:3] floatValue];
//    
//    //CGRect drawingRect = CGRectMake(0, 0, iWidth, iHeight_);
//    CGContextSetRGBStrokeColor(context, 1.0, 0.1, 0.1, 1.0);
//    CGContextSetRGBFillColor(context, 1.0, 0.1, 0.0, 1.0);
//    //CGContextFillRect(context, drawingRect);
//    
//
//    //bg
//    CGFloat fRadius = 5.0;
//    CGContextMoveToPoint(context, fRadius, 0.0f);
//    CGContextAddArc(context, iWidth - fRadius, fRadius, fRadius, -M_PI_2, 0.0f, 0);
//    CGContextAddArc(context, iWidth - fRadius, iHeight_ - fRadius, fRadius, 0, M_PI_2, 0);
//    CGContextAddArc(context, fRadius, iHeight_ - fRadius, fRadius, M_PI_2, M_PI, 0);
//    CGContextAddArc(context, fRadius, fRadius, fRadius, M_PI, M_PI * 1.5, 0);
//    CGContextDrawPath(context, kCGPathEOFillStroke);
//    
//    //draw gradient
//    CGContextSetRGBFillColor(context, 0.1, 0.1, 0, 0.6);
//    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.1, 1.0);
//    
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGFloat colors[] =
//    {
//        204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00,
//        29.0 / 255.0, 156.0 / 255.0, 215.0 / 255.0, 1.00,
//        0.0 / 255.0,  50.0 / 255.0, 126.0 / 255.0, 1.00,
//    };
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors) / (sizeof(colors[0]) * 4));
//    
//    CGFloat linearcolors[] =
//    {
//        255.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00,
//        29.0 / 255.0, 100.0 / 255.0, 215.0 / 255.0, 1.00,
//        0.0 / 255.0,  50.0 / 255.0, 126.0 / 255.0, 1.00,
//    };
//    CGGradientRef linear = CGGradientCreateWithColorComponents(rgb, linearcolors, NULL, sizeof(linearcolors) / (sizeof(linearcolors[0]) * 4));
//    CGColorSpaceRelease(rgb);
//    
//    int iAudioSapce = 4;
//    CGRect rct = CGRectMake(iAudioSapce, iAudioSapce, iAudioWidth_ - iAudioSapce, iAudioWidth_ - iAudioSapce);
//    CGPoint start, end;
//    CGFloat startRadius, endRadius;
//    start = end = CGPointMake(CGRectGetMidX(rct), CGRectGetMidY(rct));
//    startRadius = rct.size.width * 0.125;
//    endRadius = rct.size.width * 0.5;
//    CGContextDrawRadialGradient(context, gradient, start, startRadius, end, endRadius, kCGGradientDrawsBeforeStartLocation);
//    
//    /*
//     <10    30pix
//     30sec 1/2
//     5 min 1
//     */
//    
//    // drwa linear
//    if (_baudio)
//    {
//        int iW = iPlayMixW_;
//        float fTime = [_baudio.times floatValue];
//        if(fTime < 10)
//        {
//            
//        }
//        else if(fTime < 30)
//        {
//            iW += (fTime - 10) / 20 * iMaxWidth_ * 0.5;
//        }
//        else if(fTime < 5 * 60)
//        {
//            iW += iMaxWidth_ * 0.5;
//            iW += (fTime - 270 - 10) / 270 * iMaxWidth_ * 0.5;
//        }
//        else
//            iW += iMaxWidth_;
//  
//        CGRect linearRct = CGRectMake(iAudioWidth_, 0, iW, iHeight_);
//        start = CGPointMake(linearRct.origin.x, linearRct.origin.y + linearRct.size.height * 0.5);
//        end = CGPointMake(linearRct.origin.x + linearRct.size.width, linearRct.origin.y + linearRct.size.height * 0.5);
//        CGContextDrawLinearGradient(context, linear, start, end, 0);
//    }
//
//    
//}

#pragma mark --- delegate


- (void)audioPlayBtnPressed:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(audioPlayBtnPressed:)])
    {
        [self.delegate audioPlayBtnPressed:self];
    }
}

- (void)deleteAudio:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteAudio:)])
    {
        [self.delegate deleteAudio:self];
    }
}

@end

@implementation AudiosAddBtnView
@synthesize delegate;

- (void)dealloc
{
    self.delegate = nil;
}

- (id)initWithDeletegate:(id<AudiosBtnDelegate>)dlgate
{
    iHeight_ = 36;
    BBLOG();
    self = [super initWithFrame:CGRectMake(30, 0, 100, iHeight_)];
    if(self)
    {
        self.delegate = dlgate;
        self.userInteractionEnabled  = YES;
        [self setImage:[[UIImage imageNamed:@"audio_play.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10]];
        
        UIImage *micImg = [UIImage imageNamed:@"mic.png"];
        UIButton *micBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [micBtn setBackgroundImage:micImg forState:UIControlStateNormal];
        //[micBtn setBackgroundImage:[UIImage imageNamed:@"mic.png"] forState:UIControlStateHighlighted];
        [micBtn addTarget:self action:@selector(addAudioBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [micBtn setFrame:CGRectMake(10, 0, iHeight_ * 2, iHeight_)];
        [self addSubview:micBtn];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100 - 5, iHeight_)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setFont:[UIFont systemFontOfSize:8]];
        [lbl setTextAlignment:NSTextAlignmentRight];
        [lbl setText:NSLocalizedString(@"add record  ", nil)];
        [self addSubview:lbl];
    }
    return self;
}

#pragma mark --- delegate
- (void)addAudioBtnPressed:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(addAudioBtnPressed)])
    {
        [self.delegate addAudioBtnPressed];
    }
}

@end
