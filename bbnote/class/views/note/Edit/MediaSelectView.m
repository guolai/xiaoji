//
//  MediaSelectView.m
//  Zine
//
//  Created by bob on 12/5/13.
//  Copyright (c) 2013 aura marker stdio. All rights reserved.
//

#import "MediaSelectView.h"

@implementation MediaSelectView

- (id)initWithFrame:(CGRect)frame
{
    if(self =  [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
        int iBtnWidth = 60;
//        int iBtnHeight = 80;
        float fSpace = (frame.size.width - iBtnWidth * 4) / 5;
        float fLeft = fSpace;
       
        NSArray *arrayImg = @[@"editHead_Photo.png", @"editHead_Paper.png", @"editHead_Poster"];
        NSArray *arrayText = @[NSLocalizedString(@"Photo", Nil), NSLocalizedString(@"Paper", Nil), NSLocalizedString(@"Poster", Nil)];
        for (int i = 0; i < arrayImg.count; i++)
        {
            CGRect rect = CGRectMake(fLeft + (iBtnWidth + fSpace) * i, 20, iBtnWidth, iBtnWidth);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:rect];
            [btn setImage:[UIImage imageNamed:[arrayImg objectAtIndex:i]] forState:UIControlStateNormal];
            [btn setTag:(600 + i)];
            [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            rect.origin.y = rect.origin.y + rect.size.height;
            rect.size.height = 20;
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl setText:[arrayText objectAtIndex:i]];
            [lbl setFont:[UIFont systemFontOfSize:12]];
            [self addSubview:lbl];
            
        }
        
    
    }
    return self;
}

#pragma mark --event 
- (void)btnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    T_Media_Type type = btn.tag - 600;
    if(self.delegate && [self.delegate respondsToSelector:@selector(mediaSelectDidSelect:)])
    {
        [self.delegate mediaSelectDidSelect:type];
    }
}

@end
