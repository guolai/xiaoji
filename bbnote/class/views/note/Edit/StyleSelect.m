//
//  StyleSelect.m
//  Zine
//
//  Created by bob on 9/4/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import "StyleSelect.h"
#import "StyleScrView.h"
#import "BBMisc.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DataModel.h"

@implementation KBSelectView
@synthesize kbDelegate;
@synthesize kbStateType = _kbStateType;

- (void) dealloc
{
}

- (id)init{
    if(self = [super init])
    {
        [self setUserInteractionEnabled:YES];
        _kbStateType = e_KBState_B;
        UIImage *img = [UIImage imageNamed:@"edit_kb_style_bg.png"];
        self.frame = CGRectMake(0.0f, 0.0f, img.size.width, img.size.height);
        [self setImage:img];
        //[self setBackgroundColor:[UIColor redColor]];
        int iMargin = 5;
        int iBtnWidth = img.size.width / 2 - iMargin * 2;
        int  iBtnHeight = img.size.height  - iMargin * 2;
        _btnA = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnA setFrame:CGRectMake(iMargin, iMargin, iBtnWidth, iBtnHeight)];
        [_btnA setImage:[UIImage imageNamed:@"edit_kb_style_a.png"] forState:UIControlStateNormal];
        [_btnA setImage:[UIImage imageNamed:@"edit_kb_style_a_hl.png"] forState:UIControlStateHighlighted];
        [_btnA addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnA];
        
        _btnB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnB setFrame:CGRectMake(iMargin * 3 + iBtnWidth, iMargin, iBtnWidth, iBtnHeight)];
        [_btnB setImage:[UIImage imageNamed:@"edit_kb_style_b_hl.png"] forState:UIControlStateNormal];
        [_btnB setImage:[UIImage imageNamed:@"edit_kb_style_b.png"] forState:UIControlStateHighlighted];
        [_btnB addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnB];
        
        
    }
    return self;
}

- (void)btnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    BOOL bShouldHideKb = NO;
    if(btn == _btnA)
    {
        [_btnA setImage:[UIImage imageNamed:@"edit_kb_style_a_hl.png"] forState:UIControlStateNormal];
        [_btnA setImage:[UIImage imageNamed:@"edit_kb_style_a.png"] forState:UIControlStateHighlighted];
        [_btnB setImage:[UIImage imageNamed:@"edit_kb_style_b.png"] forState:UIControlStateNormal];
        [_btnB setImage:[UIImage imageNamed:@"edit_kb_style_b_hl.png"] forState:UIControlStateHighlighted];
        if(_kbStateType == e_KBState_A)
        {
            bShouldHideKb =YES;
        }
        else
        {
            _kbStateType = e_KBState_A;
        }
    }
    else
    {
        [_btnA setImage:[UIImage imageNamed:@"edit_kb_style_a.png"] forState:UIControlStateNormal];
        [_btnA setImage:[UIImage imageNamed:@"edit_kb_style_a_hl.png"] forState:UIControlStateHighlighted];
        [_btnB setImage:[UIImage imageNamed:@"edit_kb_style_b_hl.png"] forState:UIControlStateNormal];
        [_btnB setImage:[UIImage imageNamed:@"edit_kb_style_b.png"] forState:UIControlStateHighlighted];
        if(_kbStateType == e_KBState_B)
        {
            bShouldHideKb = YES;
        }
        else
        {
            _kbStateType = e_KBState_B;
        }
    }
    if(self.kbDelegate && [self.kbDelegate  respondsToSelector:@selector(keyboardDidChangeState:)])
    {
        if(bShouldHideKb)
        {
            [self.kbDelegate keyboardDidChangeState:e_KBState_Max];
        }
        else
        {
            [self.kbDelegate keyboardDidChangeState:_kbStateType];
        }
    }
}

//- (void)setKbStateType:(T_KeyBoard_Style_State)kbStateType
//{
//    if(_kbStateType != kbStateType)
//    {
//        
//    }
//}

- (void)setFrameNextToView:(UIView *)view
{
    CGRect rct = self.frame;
    rct.origin.y = view.frame.origin.y - rct.size.height;
    rct.origin.x = view.frame.size.width - rct.size.width;
    self.frame = rct;
}
@end

@implementation StyleSelectView
@synthesize arrayBtms;
@synthesize arrayStyles;
@synthesize styleDelegate;
- (void)dealloc
{
    self.arrayStyles = nil;
    self.arrayBtms = nil;
}


- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) // heigth 263 top margin 12, 3, 6, 9
    {
        float fTop = 3.0f; //10.0f;
        float fMargin = 1.5f;
        float fScrCellW = 78.0f;
        float fScrCellH = 46.0f;
        fScrCellW = (SCR_WIDTH-8)/4;
        fScrCellH *= (fScrCellW/78.0);
        
        
        self.arrayBtms = [NSMutableArray arrayWithCapacity:6];
        self.arrayStyles = [NSMutableArray arrayWithCapacity:4];
        NSArray *arrayStyle = @[@"fontFamily", @"color",  @"fontSize", @"bgColor"];
        
        [self setBackgroundColor:[UIColor colorWithRed:228/255.0 green:230/255.0 blue:232/255.0 alpha:1.0]];
        
        NSArray *array = [NSArray array];
        for (int i = 0; i < arrayStyle.count; i++)
        {
            
            T_BaseView type = e_BV_Text;
            if(i == 0)
            {
                type = e_BV_Text;
                array = @[@{@"name":kHelVetica, @"localname":@"note"},
                          @{@"name":@"snFontP1", @"localname":@"小记"},
                          @{@"name":@"snFontP2", @"localname":@"小记"},
                          @{@"name":@"FZXingKai-S04S", @"localname":@"小记"},
                          @{@"name":@"FZHuangCao-S09S", @"localname":@"小记"},
                          @{@"name":kDefatultFont, @"localname":@"小记"},
                          @{@"name":@"Kaiti SC", @"localname":@"小记"},
                          @{@"name":@"FZQingKeBenYueSongS-R-GB", @"localname":@"小记"},
                          ];
            }
            else if(i == 1)
            {
                type = e_BV_Color;
                array = @[@{@"name":@"rgba(46,49,146,1.0)"},
                          @{@"name":@"rgba(0,0,0,1.0)"},
                          @{@"name":@"rgba(117,76,36,1.0)"},
                          @{@"name":@"rgba(32,32,32,1.0)"},
                          @{@"name":@"rgba(172,172,172,1.0)"},
                          @{@"name":@"rgba(240,240,240,1.0)"},
                          @{@"name":@"rgba(56,140,228,1.0)"},
                          @{@"name":@"rgba(46,166,155,1.0)"},
                          @{@"name":@"rgba(57,181,74,1.0)"},
                          @{@"name":@"rgba(255,138,0,1.0)"},
                          @{@"name":@"rgba(237,35,8,1.0)"},
                          @{@"name":@"rgba(199,0,43,1.0)"},
                          @{@"name":@"rgba(176,79,187,1.0)"},
                          ];
            }
            else if(i == 2)
            {
                type = e_BV_Size;
                array = @[@{@"name":@"9"},
                          @{@"name":@"10"},
                          @{@"name":@"11"},
                          @{@"name":@"12"},
                          @{@"name":@"14"},
                          @{@"name":@"16"},
                          @{@"name":@"18"},
                          @{@"name":@"20"},
                          @{@"name":@"24"},
                          @{@"name":@"28"},
                          @{@"name":@"32"},
                          @{@"name":@"36"},
                  ];
            }
            else if(i == 3)
            {
                type = e_BV_BgColor;
                array = @[@{@"name":@"rgba(255,255,255,1.0)"},
                          @{@"name":@"rgba(255,255,255,0.0)"},
                          @{@"name":@"rgba(46,49,146,1.0)"},
                          @{@"name":@"rgba(117,76,36,1.0)"},
                          @{@"name":@"rgba(32,32,32,1.0)"},
                          @{@"name":@"rgba(172,172,172,1.0)"},
                          @{@"name":@"rgba(240,240,240,1.0)"},
                          @{@"name":@"rgba(56,140,228,1.0)"},
                          @{@"name":@"rgba(46,166,155,1.0)"},
                          @{@"name":@"rgba(57,181,74,1.0)"},
                          @{@"name":@"rgba(255,138,0,1.0)"},
                          @{@"name":@"rgba(237,35,8,1.0)"},
                          @{@"name":@"rgba(199,0,43,1.0)"},
                          @{@"name":@"rgba(176,79,187,1.0)"},
                          ];
            }
            
            StyleScrView *styleScrView = [[StyleScrView alloc] initWithFrame:CGRectMake(0, fTop - fMargin + (fMargin + fScrCellH) * i, SCR_WIDTH, fScrCellH) array:array width:fScrCellW height:fScrCellH type:type];
            styleScrView.strStyleType  = [arrayStyle objectAtIndex:i];
            styleScrView.textStyleDelegate = self;
            [self.arrayStyles addObject:styleScrView];
            [self addSubview:styleScrView];
        }
        
        fScrCellW += 24*2;//选中框的阴影部分
        fScrCellW -= 2*2;//margin部分
        UIImageView *imgViewSelected = [[UIImageView alloc] initWithFrame:CGRectMake(SCR_WIDTH / 2 - fScrCellW / 2, fTop - fMargin, fScrCellW, (fMargin + fScrCellH) * arrayStyle.count + fMargin * (arrayStyle.count - 1) - 5)];
        UIImage* selectedImg = [UIImage imageNamed:@"select_select.png"];
        CGSize size = selectedImg.size;
        selectedImg = [selectedImg stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2];
        [imgViewSelected setImage:selectedImg];
        imgViewSelected.userInteractionEnabled = NO;
        [self addSubview:imgViewSelected];
        
        fMargin = 10.0;
        float fOffsetW = 30;
        float fW = 28;
        float rightOffsetW = (SCR_WIDTH-fOffsetW-fMargin*2-fW*3);
        NSArray *arrayBtm = @[@{@"file":@"select_btm_0.png", @"hlfile":@"select_btm_0_hl.png", @"name":@"fontWeight,bold,normal"},
                              @{@"file":@"select_btm_1.png", @"hlfile":@"select_btm_1_hl.png", @"name":@"fontStyle,italic,normal"},
                              @{@"file":@"select_btm_2.png", @"hlfile":@"select_btm_2_hl.png", @"name":@"textDecoration,underline,none"},
                              @{@"file":@"select_btm_3.png", @"hlfile":@"select_btm_3_hl.png", @"name":@"textAlign,left,nil"},
                              @{@"file":@"select_btm_4.png", @"hlfile":@"select_btm_4_hl.png", @"name":@"textAlign,center,nil"},
                              @{@"file":@"select_btm_5.png", @"hlfile":@"select_btm_5_hl.png", @"name":@"textAlign,right,nil"},
                              ];
//        for (int i = 0; i < 6; i++) {
//            NSDictionary *dic = [arrayBtm objectAtIndex:i];
//            NSString *strImg = [dic objectForKey:@"file"];
//            NSString *strImgHl = [dic objectForKey:@"hlfile"];
//            NSArray *array = [[dic objectForKey:@"name"] componentsSeparatedByString:@","];
//            if(array.count != 3)
//            {
//                NSAssert(false, @"error");
//            }
//            
//            StyleBtn *btn = [StyleBtn buttonWithType:UIButtonTypeCustom];
//            
//            if(i < 3){
//                [btn setFrame:CGRectMake(fOffsetW + (fMargin + fW) * i, self.frame.size.height - 10 - fW, fW, fW)];
//            }
//            else{
//                [btn setFrame:CGRectMake(rightOffsetW + (fMargin + fW) * (i-3), self.frame.size.height - 10 - fW, fW, fW)];
//            }
//            btn.norImg = [UIImage imageNamed:strImg];
//            btn.hlImg = [UIImage imageNamed:strImgHl];
//            [btn setBackgroundColor:[UIColor clearColor]];
//            [btn setImage:btn.norImg forState:UIControlStateNormal];
//            [btn setImage:btn.hlImg forState:UIControlStateHighlighted];
//            [btn setTag:(600 + i)];
//            [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
//            btn.strStyle = [array objectAtIndex:2];
//            btn.strHlStyle = [array objectAtIndex:1];
//            btn.strKey = [array objectAtIndex:0];
//            btn.bPressedDown = NO;
//            [self.arrayBtms addObject:btn];
//            [self addSubview:btn];
//        }
//  
    }
    return self;
}

- (void)btnPressed:(id)sender
{
    StyleBtn *btn = (StyleBtn *)sender;
    int iTag = btn.tag - 600;
    btn.bPressedDown = !btn.bPressedDown;
    if(iTag >= 3)
    {
        for (int i = 3; i< self.arrayBtms.count; i++)
        {
            if(i != iTag)
            {
                StyleBtn *btnTemp = [self.arrayBtms objectAtIndex:i];
                btnTemp.bPressedDown = NO;
            }
        }
    }
    [self textStyleScrollDidStop:nil type:nil];
}

- (void)textStyleScrollDidStop:(NSString *)strValue type:(NSString *)strType
{
    BOOL isScrolling = NO;
    for (StyleScrView *scrView in self.arrayStyles)
    {
        if (scrView.isMoving)
        {
            isScrolling = YES;
            break;
        }
    }
    if(!isScrolling)//都已经停下，可以调用js更新样式了
    {
        if(self.styleDelegate && [self.styleDelegate respondsToSelector:@selector(keyboardDidSelectStyle:)])
        {
            [self.styleDelegate keyboardDidSelectStyle:[self getStyleDictionary]];
        }
    }
}

- (void)setCurrentStyles:(BStyle *)bstyle
{
    if(!bstyle || _bstyle == bstyle)
    {
        return;
    }
    
    
    _bstyle = bstyle;
    
    NSString *strStyle = nil;
    for (StyleScrView *styView in self.arrayStyles)
    {
        strStyle = styView.strStyleType;
        if ([strStyle isEqualToString:@"fontFamily"])
        {
            [styView setCurrentSelectItem:bstyle.strFontName];
        }
        else if ([strStyle isEqualToString:@"color"])
        {
            [styView setCurrentSelectItem:bstyle.strColor];
        }
        else if ([strStyle isEqualToString:@"fontSize"])
        {
            [styView setCurrentSelectItem:bstyle.strSize];
        }
        else if ([strStyle isEqualToString:@"bgColor"])
        {
            [styView setCurrentSelectItem:bstyle.strBgColor];
        }
        else
        {
            NSParameterAssert(false);
        }
    }

//    for (StyleBtn *btn in self.arrayBtms)
//    {
//        for (NSString *str in array)
//        {
//            if([str rangeOfString:btn.strKey].location != NSNotFound)
//            {
//                NSArray *array2 = [str componentsSeparatedByString:@"="];
//                if(array2.count == 2)
//                {
//                    if([[array2 objectAtIndex:1] isEqualToString:btn.strHlStyle])
//                    {
//                        btn.bPressedDown = YES;
//                    }
//                    else
//                        btn.bPressedDown = NO;
//                }
//                break;
//            }
//        }
//    }
}

- (BStyle *)getStyleDictionary
{
    BStyle *bstye = [[BStyle alloc] init];
    NSMutableDictionary *mtblDic = [NSMutableDictionary dictionaryWithCapacity:4];
    for (StyleScrView *scrView  in self.arrayStyles)
    {
        if ([scrView.strStyleType isEqualToString:@"fontFamily"])
        {
            bstye.strFontName = scrView.strCurStyle;
        }
        else if ([scrView.strStyleType isEqualToString:@"color"])
        {
            bstye.strColor = scrView.strCurStyle;
        }
        else if ([scrView.strStyleType isEqualToString:@"fontSize"])
        {
            bstye.strSize = scrView.strCurStyle;
        }
        else if ([scrView.strStyleType isEqualToString:@"bgColor"])
        {
            bstye.strBgColor = scrView.strCurStyle;
        }
        else
        {
            NSParameterAssert(false);
        }
        [mtblDic setObject:scrView.strCurStyle forKey:scrView.strStyleType];
    }
//    for (int i = 0; i < 3; i++)
//    {
//        StyleBtn *btn = [self.arrayBtms objectAtIndex:i];
//        [mtblDic setObject:[btn getStyle] forKey:btn.strKey];
//    }
//    NSString *strValue = nil;
//    NSString *strKey = nil;
//    BOOL bFind = NO;
//    for (int i = 3; i < 6; i++) {
//        StyleBtn *btn = [self.arrayBtms objectAtIndex:i];
//        strKey = btn.strKey;
//        strValue = [btn getStyle];
//        if(!ISEMPTY(strValue) && ![strValue isEqualToString:@"nil"])
//        {
//            bFind = YES;
//            break;
//        }
//    }
//    if(bFind)
//    {
//        [mtblDic setObject:strValue forKey:strKey];
//    }
//    else
//    {
//        [mtblDic setObject:@"left" forKey:strKey];
//    }
    return bstye;
}

@end


//static void SoundFinished(SystemSoundID soundID,void* data){
//    
//    AudioServicesDisposeSystemSoundID(soundID);
//}

@implementation XunFeiAudioInputView
@synthesize xunfeiDelegate;

- (void)dealloc
{
    BBDEALLOC();
    if(_circleTimer)
    {
        [_circleTimer invalidate];
        _circleTimer = nil;
    }
    [self removeAnimationFromView];
}


- (id)initWithFrame:(CGRect)frame
{
    if(self =  [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        _fBigScale = 3.2;
        _fPriBigScale = _fBigScale;
        _fSmllScale = 2.5;
        _fPriSmllScale = _fPriBigScale;
        UIImage *img = [UIImage imageNamed:@"edit_voiceinput.png"];
        _btnAudioInput = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAudioInput setBackgroundColor:[UIColor clearColor]];
        CGRect rct = CGRectMake(frame.size.width / 2 - img.size.width / 2, frame.size.height / 2 - img.size.height / 2, img.size.width, img.size.height);
        [_btnAudioInput setFrame:rct];
        _bigRct = rct;
        [_btnAudioInput setImage:img forState:UIControlStateNormal];
        [_btnAudioInput addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnAudioInput];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCR_WIDTH-10-55, self.frame.size.height - 25, 55, 20)];
        label.text = NSLocalizedString(@"科大讯飞", nil);
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:1.0];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        CGRect accentTipLabelRect = label.frame;
        accentTipLabelRect.origin.x = 12;
        accentTipLabelRect.size.width += 20;
        [self addAccentTipLabel:accentTipLabelRect];
        
        _imgViewBig = [[UIImageView alloc] initWithFrame:rct];
        [_imgViewBig setImage:[UIImage imageNamed:@"edit_voice_bg.png"]];
        _imgViewBig.alpha = 0.5;
        [self addSubview:_imgViewBig];
        
        _imgViewSmall = [[UIImageView alloc] initWithFrame:rct];
        _smallRct = rct;
        [_imgViewSmall setImage:[UIImage imageNamed:@"edit_voice_bg.png"]];
        [self addSubview:_imgViewSmall];
        
        [self bringSubviewToFront:_btnAudioInput];
        //[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(addAnimation) userInfo:Nil repeats:YES];
    }
    return self;
}

-(void)addAccentTipLabel:(CGRect)rect
{
    
//    UILabel *label = [[UILabel alloc] initWithFrame:rect];
//    label.text = [dict objectForKey:accent];
//    label.font=[UIFont systemFontOfSize:13];
//    label.textColor=[UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:1.0];
//    label.backgroundColor=[UIColor clearColor];
//    [self addSubview:label];
}

- (void)doShowAnimation
{
    float fZoomOut = 0.7;
    [self addZoomOutAnimationToView:_imgViewBig scaleFrom:(float)_fPriBigScale toValue:_fBigScale duration:fZoomOut name:@"showBigView"];
    [self addZoomOutAnimationToView:_imgViewSmall scaleFrom:(float)_fPriSmllScale toValue:_fSmllScale duration:fZoomOut name:@"showSmallView"];

    double delayInSeconds = 1 - fZoomOut - 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self addZoomInAnimationToView:_imgViewBig scaleFrom:(float)_fBigScale toValue:_fPriBigScale duration:1 -fZoomOut name:@"showBigView2"];
        [self addZoomInAnimationToView:_imgViewSmall scaleFrom:(float)_fSmllScale toValue:_fPriSmllScale duration:1 - fZoomOut name:@"showSmallView2"];
    });
}

- (CGRect)getRectFromView:(CGRect)priRct scaleFrom:(float)fFrom to:(float)fTo
{
    //Vlog(@"rect %@", NSStringFromCGRect(priRct));
//    float viewH = KB_IPHONE_HEIGHT;
//    if (ISiPhone6Plus) {
//        viewH = KB_IPHONE_HEIGHT_4PLUS;
//    } else if (ISiPhone6) {
//        viewH = KB_IPHONE_HEIGHT_4i6;
//    }
    
    CGRect rct = CGRectZero;
//    float fx = SCR_WIDTH / 2;
//    float fy = viewH / 2;
//    float fW = priRct.size.width;
//    float fH = priRct.size.height;
//    rct.size.width = fW * fTo / fFrom;
//    rct.size.height = fH * fTo / fFrom;
//    rct.origin.x = fx - rct.size.width / 2;
//    rct.origin.y = fy - rct.size.height / 2;
    return rct;
}

- (void)doHideAnimation
{
    [self removeAnimationFromView];

    float fBig = (_fBigScale > _fPriBigScale) ? _fPriBigScale : _fBigScale;
    float fSml = (_fSmllScale > _fPriSmllScale) ? _fPriSmllScale : _fSmllScale;
    [self addHideAnimationToView:_imgViewBig scaleFrom:(float)fBig toValue:0.01 duration:0.7 name:@"hideBigView"];
    [self addHideAnimationToView:_imgViewSmall scaleFrom:(float)fSml toValue:0.01 duration:0.7 name:@"hideSmallView"];

}

- (void)addCircleLayerAnimation
{
//    DEBUGLOG();
//    float viewH = KB_IPHONE_HEIGHT;
//    if (ISiPhone6Plus) {
//        viewH = KB_IPHONE_HEIGHT_4PLUS;
//    } else if (ISiPhone6) {
//        viewH = KB_IPHONE_HEIGHT_4i6;
//    }
//    
//    CALayer *circleLayer = [CALayer layer];
//    CGRect rct = CGRectMake(SCR_WIDTH / 2 - 5, viewH / 2 - 5, 10, 10);
//    circleLayer.frame = rct;
//    circleLayer.borderColor = ZINE_COLOR.CGColor;
//    circleLayer.borderWidth = 0.5;
//    circleLayer.cornerRadius = 5.0;
//    [self.layer insertSublayer:circleLayer below:_btnAudioInput.layer];
//    [self circleScaleBegin:circleLayer];
}

- (void)circleScaleBegin:(CALayer *)layer
{
//    const float maxScale=50.0;
//    if(!_bInputting) //点击停止后，如果 circle的半径小于 15,就向内收，否则，快速消失
//    {
//        if (layer.transform.m11< 20 && layer.transform.m11 > 2)
//        {
//            if (layer.transform.m11 <=4.0)
//            {
//                [layer setTransform:CATransform3DMakeScale(0.8, 0.8, 1.0)];
//                layer.borderWidth = layer.borderWidth * 0.4;
//            }
//            else
//            {
//                [layer setTransform:CATransform3DScale(layer.transform, 0.9, 0.9, 1.0)];
//                layer.opacity = layer.opacity * 0.96;
//                //layer.borderWidth = layer.borderWidth * 1;
//            }
//            int irandom =arc4random()%5;
//            [self performSelector:_cmd withObject:layer afterDelay:0.02 + irandom * 0.01];
//        }
//        else
//        {
//            DEBUGLOG();
//            [layer removeFromSuperlayer];
//        }
//
//    }
//    else
//    {
//        if (layer.transform.m11<maxScale)
//        {
//            if (layer.transform.m11 <=2.0)
//            {
//                [layer setTransform:CATransform3DMakeScale(3, 3, 1.0)];
//                layer.borderWidth = layer.borderWidth * 0.4;
//            }
//            else
//            {
//                [layer setTransform:CATransform3DScale(layer.transform, 1.1, 1.1, 1.0)];
//                layer.opacity = layer.opacity * 0.96;
//                layer.borderWidth = layer.borderWidth * 0.9;
//            }
//            int irandom =arc4random()%5;
//            [self performSelector:_cmd withObject:layer afterDelay:0.05 + irandom * 0.01];
//        }
//        else
//        {
//            DEBUGLOG();
//            [layer removeFromSuperlayer];
//        }
//    }
}

- (void)addZoomOutAnimationToView:(UIView *)view scaleFrom:(float)fFrom toValue:(float)fValue duration:(float)fDuration name:(NSString *)strName
{
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.fromValue = [NSNumber numberWithFloat:fFrom];
	scaleAnimation.toValue = [NSNumber numberWithFloat:fValue];
	scaleAnimation.duration = fDuration;
	scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
    [view.layer addAnimation:scaleAnimation forKey:strName];
}

- (void)addZoomInAnimationToView:(UIView *)view scaleFrom:(float)fFrom toValue:(float)fValue duration:(float)fDuration name:(NSString *)strName
{
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation2.fromValue = [NSNumber numberWithFloat:fFrom];
	scaleAnimation2.toValue = [NSNumber numberWithFloat:fValue];
	scaleAnimation2.duration = fDuration;
	scaleAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [view.layer addAnimation:scaleAnimation2 forKey:strName];
}

- (void)addHideAnimationToView:(UIView *)view  scaleFrom:(float)fFrom toValue:(float)fValue duration:(float)fDuration name:(NSString *)strName
{
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.fromValue = [NSNumber numberWithFloat:fFrom];
	scaleAnimation.toValue = [NSNumber numberWithFloat:fValue];
	scaleAnimation.duration = fDuration;
	scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [view.layer addAnimation:scaleAnimation forKey:strName];
}

- (void)startCircleAnimation
{
    if(_circleTimer)
    {
        [_circleTimer invalidate];
        _circleTimer = nil;
    }
    _circleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTrigger) userInfo:nil repeats:YES];
}

- (void)timerTrigger
{
//    int irandom = arc4random()%5;
//    int irandom2 = arc4random()%9;
//    float fValue = irandom + irandom2 * 0.1;
//    if(fValue < 1.5)
//    {
//        fValue = 1.5 + irandom2 * 0.1;
//    }
//    _fPriSmllScale = _fSmllScale;
//    _fPriBigScale = _fBigScale;
//    _fBigScale = fValue;
//    if(_fBigScale >= 5.0)
//    {
//        _fBigScale = 5.0;
//        _fSmllScale = _fBigScale * 0.9;
//    }
//    else if(_fBigScale > 3.0)
//    {
//        _fSmllScale = 2 + (_fBigScale  - 3) * 0.8;
//    }
//    else
//    {
//        _fSmllScale = 1.5 + (_fBigScale - 1.5) * 0.88;
//    }
//
//    Vlog(@"%f-%f, %f- %f", _fBigScale, _fPriBigScale, _fSmllScale, _fPriSmllScale);
    [self addCircleLayerAnimation];

}

- (void)stopCircleAnimation
{
    if(_circleTimer)
    {
        [_circleTimer invalidate];
        _circleTimer = nil;
    }
    CGRect rct = _btnAudioInput.frame;
    [_imgViewSmall setFrame:rct];
    [_imgViewBig setFrame:rct];
    [self removeAnimationFromView];
    [self doHideAnimation];
}

- (void)beginAudioInput
{
    // 先播放音效，再开启声音输入，可以消除音效带来的干扰；
//    [self playSystemSoundService:@"MicrophoneTurnOn"];
//    
//    _bInputting = YES;
//    CGRect rct = _btnAudioInput.frame;
//    float fRadiu = rct.size.width / 2;
//    _fBigScale = 1.3;
//    _fPriBigScale = _fBigScale;
//    _fTempScale = _fBigScale;
//    _fSmllScale = 0.8*_fBigScale;
//    _fPriSmllScale = _fPriBigScale;
//    
//    
//    CGRect bigRct = CGRectMake(SCR_WIDTH / 2 - fRadiu * _fBigScale, viewH / 2 - fRadiu * _fBigScale, fRadiu  * _fBigScale * 2, fRadiu  * _fBigScale * 2);
//    [_imgViewBig setFrame:bigRct];
//    CGRect smlRct = CGRectMake(SCR_WIDTH / 2 - fRadiu * _fSmllScale, viewH / 2 - fRadiu * _fSmllScale, fRadiu * _fSmllScale * 2, fRadiu * _fSmllScale * 2);
//    [_imgViewSmall setFrame:smlRct];
//    [self addCircleLayerAnimation];
//    [self startCircleAnimation];
}

- (void)endAudioInputWithAnimatio:(BOOL)animation
{
//    if(_circleTimer)
//    {
//        [_circleTimer invalidate];
//        _circleTimer = nil;
//    }
//    if(!_bInputting)
//    {
//        return;
//    }
//    [self playSystemSoundService:@"MicrophoneTurnOff"];
//    _bInputting = NO;
//    if(animation)
//    {
//         [self stopCircleAnimation];
//    }
//    else
//    {
//        [self removeAnimationFromView];
//    }

}

- (void)removeAnimationFromView
{
    [_imgViewSmall.layer removeAllAnimations];
    [_imgViewBig.layer removeAllAnimations];
    [self.layer removeAllAnimations];
}

- (void)btnPressed:(id)sender
{
    if(_bInputting)
    {
        
        [self endAudioInputWithAnimatio:YES];
        if(self.xunfeiDelegate && [self.xunfeiDelegate respondsToSelector:@selector(keyboardXunFeiInputDidStop)])
        {
            [self.xunfeiDelegate keyboardXunFeiInputDidStop];
        }

    }
    else
    {
        [self beginAudioInput];
        if(self.xunfeiDelegate && [self.xunfeiDelegate respondsToSelector:@selector(keyboardXunFeiInputDidBegin)])
        {
            [self.xunfeiDelegate keyboardXunFeiInputDidBegin];
        }
    }
}


- (void)setCurrentDecibel:(float)fDecibel//语音分贝1 ~ 30  转为 1 ~ 4
{
//    static BOOL  bShoudAdd = YES;
//    if (fDecibel > 25) {
//        fDecibel  = 25;
//    }
//    else if(fDecibel < 0)
//    {
//        fDecibel = 0;
//    }
//
//    float fTmp = (fDecibel*fDecibel) / (13*13);
//    fTmp += 1.3;
//
//    // 等动画完成后再进行另外一个动画，动画的时间是0.5秒（ 0.3秒太快，1秒太慢 ）
//    if (!bShoudAdd) {
//        return;
//    }
//    
//    _fBigScale = fTmp;
//    _fSmllScale = 0.8*_fBigScale;
//    bShoudAdd = NO;
//    
//    [self doShowAnimation];
//    double delayInSeconds = 0.5;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        bShoudAdd = YES;
//    });
}

- (BOOL)isInputting
{
    return _bInputting;
}

- (void)playSystemSoundService:(NSString *)strName
{
//    CFBundleRef mainBundle;
//    mainBundle = CFBundleGetMainBundle ();
//    CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle,(__bridge CFStringRef)strName, CFSTR("mp3"),NULL);
//    SystemSoundID soundID;
//    OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)soundFileURLRef, &soundID);
//    CFRelease(soundFileURLRef);
//    if (err) {
//        Vlog(@"Error occurred assigning system sound!");
//        return;
//    }
//    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, SoundFinished,NULL);
//    AudioServicesPlaySystemSound(soundID);
}

@end

@implementation StyleBtn
@synthesize strStyle;
@synthesize strHlStyle;
@synthesize strKey;
@synthesize hlImg;
@synthesize norImg;
@synthesize bPressedDown = _bPressedDown;
- (void)dealloc
{
    self.strKey = nil;
    self.strHlStyle = nil;
    self.strStyle = nil;
    self.hlImg = nil;
    self.norImg = nil;
}

- (void)setBPressedDown:(BOOL)bPressedDown
{
    if (_bPressedDown != bPressedDown) {
        _bPressedDown = bPressedDown;
        if(_bPressedDown)
        {
            [self setImage:hlImg forState:UIControlStateNormal];
            [self setImage:norImg forState:UIControlStateHighlighted];
        }
        else
        {
            [self setImage:norImg forState:UIControlStateNormal];
            [self setImage:hlImg forState:UIControlStateHighlighted];
        }
    }
}

- (NSString *)getStyle
{
    if(_bPressedDown)
        return strHlStyle;
    else
        return strStyle;
}

@end
