//
//  EditHeadView.m
//  Zine
//
//  Created by user1 on 13-7-30.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import "EditHeadView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EditHeadView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGFloat viewYPos = 0.0;
        NSString* bgImageName = @"editHead_Bg.png";
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            //ios 7 state bar alway appearance
            viewYPos += 20;
            bgImageName = @"editHead_ios7.0_Bg.png";
        }
        
        //bg image
        CGRect bgRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIImage* bgImage = [UIImage imageNamed:bgImageName];
        UIImageView* bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        bgImageView.frame = bgRect;
        [self addSubview:bgImageView];
        
        //init Toolbar buttons
        int btnWidth, btnHeight;
        btnWidth = btnHeight = 44;
        int bordXSpan = 10;
        
        //tag button
        CGRect btnRect = CGRectMake(bordXSpan, viewYPos, btnWidth, btnHeight);
//        UIButton* tagBtn = [[[UIButton alloc] initWithFrame:btnRect] autorelease];
//        [tagBtn setImage:[UIImage imageNamed:@"editHead_Tag_Normal.png"] forState:UIControlStateNormal];
//        [tagBtn setImage:[UIImage imageNamed:@"editHead_Tag_Pressed.png"] forState:UIControlStateHighlighted];
//        [tagBtn addTarget:self action:@selector(tagToolbarSelected:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:tagBtn];
        
        //finish
        btnRect = CGRectMake(frame.size.width-bordXSpan/2-btnWidth, viewYPos, btnWidth, btnHeight);
        _finishEditBtn = [[UIButton alloc] initWithFrame:btnRect];
        [_finishEditBtn setImage:[UIImage imageNamed:@"editHead_Finish_Normal.png"] forState:UIControlStateNormal];
        [_finishEditBtn setImage:[UIImage imageNamed:@"editHead_Finish_Pressed.png"] forState:UIControlStateHighlighted];
        [_finishEditBtn addTarget:self action:@selector(finishEditToolbarSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_finishEditBtn];
        
        //auto save
        CGRect autoSaveRect = btnRect;
        autoSaveRect.origin.y += 5;
        _autoSaveView = [[UIImageView alloc] initWithFrame:autoSaveRect];
        _autoSaveView.image = [UIImage imageNamed:@"editHead_AutoSave.png"];
        _autoSaveView.hidden = YES;
        [self addSubview:_autoSaveView];
        
        //photo button
//        btnRect = CGRectMake(bordXSpan+btnWidth+10, viewYPos, btnWidth, btnHeight);
        btnRect = CGRectMake(bordXSpan, viewYPos, btnWidth, btnHeight);
        UIButton* photoBtn = [[UIButton alloc] initWithFrame:btnRect];
        [photoBtn setImage:[UIImage imageNamed:@"editHead_Photo_Normal.png"] forState:UIControlStateNormal];
        [photoBtn setImage:[UIImage imageNamed:@"editHead_Photo_Pressed.png"] forState:UIControlStateHighlighted];
        [photoBtn addTarget:self action:@selector(photoToolbarSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:photoBtn];
        
        //map button
//        btnRect.origin.x += btnWidth+10;
//        UIButton* mapBtn = [[[UIButton alloc] initWithFrame:btnRect] autorelease];
//        [mapBtn setImage:[UIImage imageNamed:@"editHead_Map_Normal.png"] forState:UIControlStateNormal];
//        [mapBtn setImage:[UIImage imageNamed:@"editHead_Map_Pressed.png"] forState:UIControlStateHighlighted];
//        [mapBtn addTarget:self action:@selector(mapToolbarSelected:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:mapBtn];
        
        //video button
//        btnRect.origin.x += btnWidth+10;
//        UIButton* videoBtn = [[[UIButton alloc] initWithFrame:btnRect] autorelease];
//        [videoBtn setImage:[UIImage imageNamed:@"editHead_Video_Normal.png"] forState:UIControlStateNormal];
//        [videoBtn setImage:[UIImage imageNamed:@"editHead_Video_Pressed.png"] forState:UIControlStateHighlighted];
//        [videoBtn addTarget:self action:@selector(videoToolbarSelected:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:videoBtn];
        
        //brush button
//        btnRect.origin.x += btnWidth+10;
//        UIButton* brushBtn = [[[UIButton alloc] initWithFrame:btnRect] autorelease];
//        [brushBtn setImage:[UIImage imageNamed:@"editHead_Brush_Normal.png"] forState:UIControlStateNormal];
//        [brushBtn setImage:[UIImage imageNamed:@"editHead_Brush_Pressed.png"] forState:UIControlStateHighlighted];
//        [brushBtn addTarget:self action:@selector(brushToolbarSelected:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:brushBtn];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma button touchUpInSide selector
- (void)tagToolbarSelected:(id)sender {
    [self handleToolbarSelected:sender type:EditHeadTagBar];
}

- (void)finishEditToolbarSelected:(id)sender {
    [self handleToolbarSelected:sender type:EditHeadFinishEditBar];
}

- (void)photoToolbarSelected:(id)sender {
    [self handleToolbarSelected:sender type:EditHeadPhotoBar];
}

- (void)mapToolbarSelected:(id)sender {
    [self handleToolbarSelected:sender type:EditHeadMapBar];
}

- (void)videoToolbarSelected:(id)sender {
    [self handleToolbarSelected:sender type:EditHeadVideoBar];
}

- (void)brushToolbarSelected:(id)sender {
    [self handleToolbarSelected:sender type:EditHeadBrushBar];
}

- (void)handleToolbarSelected:(id)sender type:(EditHeadToolbarType)type {
    if (self.delegate) {
        [self.delegate headToolbarSelected:sender type:type];
    }
}

#pragma mark - auto save rotate animate
- (void)startAutoSaveAnimate {
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animate.duration=1.8;
    animate.repeatCount=MAXFLOAT;
    animate.fromValue=@(-M_PI);
    animate.toValue=@(M_PI);
    [_autoSaveView.layer removeAllAnimations];
    [_autoSaveView.layer addAnimation:animate forKey:@"rotate"];
    
    _autoSaveView.hidden = NO;
    _finishEditBtn.hidden = YES;
}

- (void)stopAutoSaveAnimate {
    [_autoSaveView.layer removeAnimationForKey:@"rotate"];
    
    _autoSaveView.hidden = YES;
    _finishEditBtn.hidden = NO;
}

@end


@implementation LoadProgressView

- (void)setCurrentProgress:(float)fProgrss
{
    _fProgress = fProgrss;
    [self setNeedsDisplay];
    
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
//    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, [BBSkin shareSkin].titleColor.CGColor);
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGRect tempRct = CGRectMake(0, 0, rect.size.width * _fProgress, rect.size.height);
    CGContextFillRect(context, tempRct);
}

@end




