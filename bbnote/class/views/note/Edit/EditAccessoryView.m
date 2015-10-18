//
//  EditAccessoryView.m
//  Zine
//
//  Created by user1 on 13-8-1.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import "EditAccessoryView.h"

@implementation KBBtn


- (instancetype)init
{
    if(self = [super init])
    {
        int iBtnWidth = 44;
        int iFontIcon = 20;
        self.fontImg = [[FontImge alloc] initWithFrame:CGRectMake((iBtnWidth - 5 - iFontIcon), (iBtnWidth - iFontIcon) / 2, iFontIcon + 5, iFontIcon)];
        [self addSubview:self.fontImg];
        self.fontImg.bgViewColor = [UIColor clearColor];
        self.fontImg.iconImgColor = [BBSkin shareSkin].titleBgColor;
    }
    return self;
}

- (void)setBubttonHl:(BOOL)bValue
{
    if(bValue)
    {
        self.fontImg.iconImgColor = [BBSkin shareSkin].titleBgColor;
    }
    else
    {
        self.fontImg.iconImgColor = [UIColor grayColor];
    }
}
@end

@implementation EditAccessoryView
@synthesize slctState = _slctState;



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
        float iSpace = 10;
        float iBtnWidth = 44;

        NSArray *array = @[@(FAIconPicture), @(FAIconHeart), @(FAIconFont), @(FAIconThLarge)];
        
        float iMargin = (SCR_WIDTH - iSpace * (array.count - 1) - iBtnWidth * array.count) /(array.count + 1);
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
        btn.fontImg.iconName = [[array objectAtIndex:i] integerValue];
        [btn setFrame:CGRectMake(iSpace, 0, iBtnWidth, iBtnWidth)];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_mulArray addObject:btn];
        i++;

        iSpace += iBtnWidth;
        iSpace += iMargin;
        btn = [[KBBtn alloc] init];
        [btn setTag:e_KB_Paper + 900];
        btn.fontImg.iconName = [[array objectAtIndex:i] integerValue];
        [btn setFrame:CGRectMake(iSpace, 0, iBtnWidth, iBtnWidth)];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_mulArray addObject:btn];
        i++;
        
        iSpace += iBtnWidth;
        iSpace += iMargin;
        btn = [[KBBtn alloc] init];
        [btn setTag:e_KB_Style + 900];
        btn.fontImg.iconName = [[array objectAtIndex:i] integerValue];
        [btn setFrame:CGRectMake(iSpace, 0, iBtnWidth, iBtnWidth)];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_mulArray addObject:btn];
        i++;
        
        iSpace += iBtnWidth;
        iSpace += iMargin;
        btn = [[KBBtn alloc] init];
        [btn setTag:e_KB_KeyBoard + 900];
        btn.fontImg.iconName = [[array objectAtIndex:i] integerValue];
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
