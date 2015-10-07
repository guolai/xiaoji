//
//  EditAccessoryView.m
//  Zine
//
//  Created by user1 on 13-8-1.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import "EditAccessoryView.h"


@implementation KBSwitchBtn
@synthesize swithstate = _swithstate;
@synthesize strKBImg;
@synthesize strMicImg;
@synthesize strMicImgHl;
@synthesize strKBImgHl;

- (void)dealloc
{
    self.strKBImg = nil;
    self.strKBImgHl = nil;
    self.strMicImg = nil;
    self.strMicImgHl = nil;
}

- (void)switchBtnToState:(T_Accessory_Style_State)style
{

    if(style == e_KBSlct_Keyboard)//当前状态是键盘
    {
        if(self.strKBImg)
        {
            [self setImage:[UIImage imageNamed:self.strKBImgHl] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:self.strKBImg] forState:UIControlStateHighlighted];
        }
        else
        {
            [self setImage:nil forState:UIControlStateNormal];
            [self setImage:nil forState:UIControlStateHighlighted];
        }
 
    }
    else
    {
         if(self.strKBImg)
         {
             
         }
        else
        {
            [self setImage:[UIImage imageNamed:self.strMicImgHl] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:self.strMicImg] forState:UIControlStateHighlighted];
        }

    }
    self.swithstate = style;
}
- (void)setBubttonHl:(BOOL)bValue
{
    if(!bValue)
    {
        if(_swithstate == e_KBSlct_Keyboard)
        {
            if(self.strKBImg)
            {
                
            }
            else
            {
                
            }
            [self setImage:[UIImage imageNamed:self.strKBImgHl] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:self.strKBImg] forState:UIControlStateHighlighted];
        }
        else
        {
            [self setImage:[UIImage imageNamed:self.strMicImgHl] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:self.strMicImg] forState:UIControlStateHighlighted];
        }
    }
    else
    {
        if(_swithstate == e_KBSlct_Keyboard)
        {
            if(self.strKBImg)
            {
                
            }
            else
            {
                
            }
            [self setImage:[UIImage imageNamed:self.strKBImg] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:self.strKBImgHl] forState:UIControlStateHighlighted];
        }
        else
        {
            if(self.strKBImg)
            {
                
            }
  
            [self setImage:[UIImage imageNamed:self.strMicImg] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:self.strMicImgHl] forState:UIControlStateHighlighted];
        }
    }

}
@end

@implementation KBBtn
@synthesize strHlImg;
@synthesize strImg;

- (void)dealloc
{
    self.strHlImg = nil;
    self.strImg = nil;
}

- (void)setBubttonHl:(BOOL)bValue
{
    if(bValue)
    {
        [self setImage:[UIImage imageNamed:self.strHlImg] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:self.strImg] forState:UIControlStateHighlighted];
    }
    else
    {
        [self setImage:[UIImage imageNamed:self.strImg] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:self.strHlImg] forState:UIControlStateHighlighted];
    }
}
@end

@implementation EditAccessoryView
@synthesize slctState = _slctState;

- (void)dealloc
{
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //bg image
        CGRect bgRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIImage* bgImage = [UIImage imageNamed:@"editAccessoryView_Bg.png"];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
        UIImageView* bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        bgImageView.frame = bgRect;
        [self addSubview:bgImageView];
        NSArray *arrayImg = @[@"editAccessoryView_Microphone_Normal.png", @"edit_style.png", @"editAccessoryView_VoiceKeyboard_Normal.png"];
        NSArray *arrayHlImg = @[@"editAccessoryView_Microphone_Pressed.png", @"edit_style_hl.png", @"editAccessoryView_VoiceKeyboard_Pressed.png"];
        float iSpace = 10;
        float iBtnWidth = 44;

        float iMargin = (SCR_WIDTH - iSpace * 2 - iBtnWidth * 3) /4;
        _mulArray = [NSMutableArray arrayWithCapacity:3];

        
        _lblPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(50, (frame.size.height - 12) / 2, self.frame.size.width - 50, 12)];
        [_lblPlaceHolder setTextAlignment:NSTextAlignmentCenter];
        [_lblPlaceHolder setFont:[UIFont italicSystemFontOfSize:12]];
        [_lblPlaceHolder setTextColor:[UIColor lightGrayColor]];
        [_lblPlaceHolder setText:NSLocalizedString(@"Please click on the text to edit", Nil)];
        
        _lblPlaceHolder.backgroundColor = [UIColor clearColor];
        [self addSubview:_lblPlaceHolder];
        

        int i = 0;
        iSpace += iMargin;
        KBBtn *btn = [[KBBtn alloc] init];
        [btn setTag:e_KB_Media + 900];
        btn.strImg = [arrayImg objectAtIndex:i];
        btn.strHlImg = [arrayHlImg objectAtIndex:i];
        [btn setFrame:CGRectMake(iSpace, 0, iBtnWidth, iBtnWidth)];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_mulArray addObject:btn];
        i++;

        
        iSpace += iBtnWidth;
        iSpace += iMargin;
        btn = [[KBBtn alloc] init];
        [btn setTag:e_KB_Style + 900];
        btn.strImg = [arrayImg objectAtIndex:i];
        btn.strHlImg = [arrayHlImg objectAtIndex:i];
        [btn setFrame:CGRectMake(iSpace, 0, iBtnWidth, iBtnWidth)];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_mulArray addObject:btn];
        i++;
        
        iSpace += iBtnWidth;
        iSpace += iMargin;
        btn = [[KBBtn alloc] init];
        [btn setTag:e_KB_KeyBoard + 900];
        btn.strImg = [arrayImg objectAtIndex:i];
        btn.strHlImg = [arrayHlImg objectAtIndex:i];
        [btn setFrame:CGRectMake(iSpace, 0, iBtnWidth, iBtnWidth)];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_mulArray addObject:btn];

     
        [self resetKeyBoardBtnstatus];
    }
    return self;
}


#pragma button touchUpInSide selector

- (void)btnPressed:(id)sender
{
    KBBtn *btn  = (KBBtn *)sender;
    int itag = btn.tag - 900;
    if(itag >= e_KB_Max || itag < e_KB_KeyBoard)
        return;
    for (KBBtn *tmpbtn in _mulArray) {
        [tmpbtn setBubttonHl:NO];
    }

    [btn setBubttonHl:YES];


    if(self.btndelegate && [self.btndelegate respondsToSelector:@selector(accessoryToolbarSelected:type:)])
    {
        [self.btndelegate accessoryToolbarSelected:Nil type:itag];
    }
    
}

- (void)setDefaultKeyBoardBtnStauts
{
    _slctState = e_KBSlct_Keyboard;
    _lblPlaceHolder.hidden = YES;
    //[_switchBtn switchBtnToState:e_KBSlct_Keyboard];
    for (KBBtn *tmpbtn in _mulArray) {
        [tmpbtn setHidden:NO];
        if(tmpbtn.tag == 900 + e_KB_KeyBoard)
        {
            [tmpbtn setBubttonHl:YES];
        }
        else
        {
            [tmpbtn setBubttonHl:NO];
        }
        
    }
}

- (void)resetKeyBoardBtnstatus
{
    _slctState = e_KBSlct_Max;
    //[_switchBtn switchBtnToState:e_KBSlct_Keyboard];
//    _lblPlaceHolder.hidden = NO;
//    for (KBBtn *tmpbtn in _mulArray) {
//        [tmpbtn setBubttonHl:NO];
//        [tmpbtn setHidden:YES];        
//    }
}

- (void)setFrameNextToView:(UIView *)view
{
    CGRect rct = self.frame;
    rct.origin.y = view.frame.origin.y - rct.size.height;
    rct.origin.x = view.frame.size.width - rct.size.width;
    self.frame = rct;
}
- (void)setFrameNextToKeyboard:(UIView *)view
{
    CGRect rct = self.frame;
    rct.origin.y = view.frame.origin.y - rct.size.height;
    rct.origin.x = view.frame.size.width - rct.size.width;
    self.frame = rct;
}

@end
