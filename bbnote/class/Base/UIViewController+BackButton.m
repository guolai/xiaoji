//
//  UIViewController+BackButton.m
//  M6s
//
//  Created by zhuhb on 13-4-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "UIViewController+BackButton.h"



@implementation UIViewController (BackButton)

- (void)showBackButton:(NSString *)strBack action:(SEL)action
{
    if(self.navigationController)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        int iNavBarH = 44;
        int iImgHeight = 33;
        NSString *str = strBack;
        if(ISEMPTY(str))
        {
            str = NSLocalizedString(@"Back", nil);
        }
        str = [NSString stringWithFormat:@"   %@", str];
        UIImage *img = nil;// = [UIImage imageNamed:@"nav_back_green.png"];
        UIImage *hlImg = nil;//= [UIImage imageNamed:@"nav_back_green_hl.png"];
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize size = [str sizeWithFont:font forWidth:160 lineBreakMode:NSLineBreakByTruncatingTail];
        [btn setFrame:CGRectMake(0, (iNavBarH - iImgHeight) / 2, size.width, iImgHeight)];
        [btn.titleLabel setFont:font];
        [btn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [btn setTitle:str forState:UIControlStateNormal];
        EBBSKIN_TYPE skintype = [BBSkin shareSkin].skinType;
        switch (skintype) {
         
            case eSkin_White:
            {
                img = [UIImage imageNamed:@"nav_back_gray.png"];
                hlImg = [UIImage imageNamed:@"nav_back_gray_hl.png"];
                
                [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                
                [btn setBackgroundImage:[img stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateNormal];
                [btn setBackgroundImage:[hlImg stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateHighlighted];
            }
                break;
            default:
            {
                img = [UIImage imageNamed:@"nav_back_white.png"];
                hlImg = [UIImage imageNamed:@"nav_back_white_hl.png"];
                
                [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                
                [btn setBackgroundImage:[img stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateNormal];
                [btn setBackgroundImage:[hlImg stretchableImageWithLeftCapWidth:19 topCapHeight:0] forState:UIControlStateHighlighted];
            }
                break;
        }
        if(action)
        {
            [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [btn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
    }

}

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showLeftButton:(NSString *)strTitle withImage:(NSString *)strImg highlightImge:(NSString *)strHlImg andEvent:(SEL)action
{
    if(self.navigationController)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(ISEMPTY(strTitle) && ISEMPTY(strImg))
            return;
        if(!ISEMPTY(strTitle))
        {
            EBBSKIN_TYPE skintype = [BBSkin shareSkin].skinType;
            switch (skintype) {
                case eSkin_White:
                {
                    [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:115/255.0 blue:118/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:115/255.0 blue:118/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
                default:
                {
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
            }
            
            UIFont *font = [UIFont systemFontOfSize:16];
            [btn.titleLabel setFont:font];
            [btn setTitle:strTitle forState:UIControlStateNormal];
            CGSize size = [strTitle sizeWithFont:font forWidth:160 lineBreakMode:NSLineBreakByTruncatingTail];
            [btn  setFrame:CGRectMake(0, 0, size.width, 44)];
        }
        if(!ISEMPTY(strImg))
        {
            UIImage *img = [UIImage imageNamed:strImg];
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            if(!ISEMPTY(strHlImg))
            {
                [btn setBackgroundImage:[UIImage imageNamed:strHlImg] forState:UIControlStateHighlighted];
            }
            [btn  setFrame:CGRectMake(0, (44 - img.size.height) / 2, img.size.width, img.size.height)];
        }
        
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void)showRigthButton:(NSString *)strTitle withImage:(NSString *)strImg highlightImge:(NSString *)strHlImg  andEvent:(SEL)action
{
    if(self.navigationController)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(ISEMPTY(strTitle) && ISEMPTY(strImg))
            return;
        if(!ISEMPTY(strTitle))
        {
            EBBSKIN_TYPE skintype = [BBSkin shareSkin].skinType;
            switch (skintype) {
                case eSkin_White:
                {
                    
                    [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:115/255.0 blue:118/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:108/255.0 green:115/255.0 blue:118/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
                default:
                {
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.7] forState:UIControlStateHighlighted];
                }
                    break;
            }
            
            UIFont *font = [UIFont systemFontOfSize:16];
           
            [btn.titleLabel setFont:font];
            [btn setTitle:strTitle forState:UIControlStateNormal];
            CGSize size = [strTitle sizeWithFont:font forWidth:160 lineBreakMode:NSLineBreakByTruncatingTail];
            [btn  setFrame:CGRectMake(0, 0, size.width, 44)];
        }
        if(!ISEMPTY(strImg))
        {
            UIImage *img = [UIImage imageNamed:strImg];
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            if(!ISEMPTY(strHlImg))
            {
                [btn setBackgroundImage:[UIImage imageNamed:strHlImg] forState:UIControlStateHighlighted];
            }
            float fWidth = img.size.width > 40? 40:img.size.width;
            float fHeight = img.size.height > 40 ? 40:img.size.height;
            [btn  setFrame:CGRectMake(0, (44 - fHeight) / 2, fWidth, fHeight)];
        }
        else
        {
            //            UIImage *bgImge = [UIImage imageNamed:@"btn_bg.png"];
            //           [btn setBackgroundColor:[UIColor colorWithPatternImage:bgImge]];
            
        }
        
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)showRigthButton:(NSString *)strTitle withTopImage:(NSString *)strImg tophighlightImge:(NSString *)strHlImg  andEvent:(SEL)action
{
    if(self.navigationController)
    {
        if(ISEMPTY(strTitle) || ISEMPTY(strImg))
        {
            assert(false);
        }
        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize size = [strTitle sizeWithFont:font forWidth:160 lineBreakMode:NSLineBreakByTruncatingTail];
        float fWidth = size.width > 60 ? size.width : 60;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, fWidth, 44)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
      

        UIImage *img = [UIImage imageNamed:strImg];
        float fImgheight = 30;
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        if(!ISEMPTY(strHlImg))
        {
            [btn setBackgroundImage:[UIImage imageNamed:strHlImg] forState:UIControlStateHighlighted];
        }
        [btn  setFrame:CGRectMake((fWidth - fImgheight) / 2, 0, fImgheight, fImgheight)];
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, fImgheight, fWidth, 12)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl  setFont:font];
        [lbl setTextAlignment:NSTextAlignmentCenter];
//        [lbl  setTextColor:MECOLOR];
        [lbl setText:strTitle];
        [view addSubview:lbl];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.rightBarButtonItem = item;
    }
}


- (void)showTitle:(NSString *)strTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    EBBSKIN_TYPE skintype = [BBSkin shareSkin].skinType;
    switch (skintype) {

        case eSkin_White:
        {
            label.textColor = [UIColor colorWithRed:108/255.0 green:115/255.0 blue:118/255.0 alpha:1.0];
        }
            break;
        default:
        {
            label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        }
            break;
    }
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.text = strTitle;
    self.navigationItem.titleView = label;
}

- (void)showBrowsePicture:(NSString *)strOrder andMonthDay:(NSString *)strTime andWeek:(NSString *)strWeek
{
    int iStatubarHeight = self.navigationController.navigationBar.bounds.size.height;
    int iFont = 12;
    if(iStatubarHeight != 44)
    {
        iFont = 10;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 5, SCR_WIDTH - 60 * 2, SCR_TOPBAR - 10)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [BBSkin shareSkin].titleColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    label.text = strOrder;
    [view addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height / 2)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [BBSkin shareSkin].titleColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:iFont];
    label.text = strTime;
    [view addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2, view.frame.size.height / 2, view.frame.size.width / 2, view.frame.size.height / 2)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [BBSkin shareSkin].titleColor;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:iFont];
    label.text = strWeek;
    [view addSubview:label];
    self.navigationItem.titleView = view;
}
@end
