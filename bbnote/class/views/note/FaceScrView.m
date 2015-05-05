//
//  FaceScrView.m
//  bbnote
//
//  Created by Apple on 13-5-8.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "FaceScrView.h"

@implementation FaceScrView
@synthesize facedelegate;
@synthesize isHiden;


- (id)initWithDelegate:(id<FaceClickDelegate>)dele
{
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, SCR_WIDTH, 216.0f)]) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack.png"]]];
        iTag_ = 200;
        self.facedelegate = dele;
        scrView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCR_WIDTH, 190.0f)];
        scrView_.pagingEnabled = YES;
        [scrView_ setBackgroundColor:[UIColor clearColor]];
        [scrView_ setContentSize:CGSizeMake((99 / 28 + 1) * [BBAutoSize screenWidth], 190.0f)];
        scrView_.showsHorizontalScrollIndicator = NO;
        scrView_.showsVerticalScrollIndicator = NO;
        scrView_.delegate = self;
        [self addSubview:scrView_];
        float fMargin = 6;
        float fSpace = 0;
        if(isPhone6)
        {
            fMargin = 18;
            fSpace = ([BBAutoSize screenWidth] - 24 - 320) / 6;
        }
        
        for (int i = 1; i <= 99; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = iTag_ + i;
            [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn setFrame:CGRectMake((((i-1)%28)%7)*(44+fSpace)+fMargin+((i-1)/28*[BBAutoSize screenWidth]), (((i-1)%28)/7)*44+8, 44, 44)];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%.3i.png", i]] forState:UIControlStateNormal];
            [scrView_ addSubview:btn];
        }
        pageControl_ = [[GrayPageControl alloc] initWithFrame:CGRectMake(([BBAutoSize screenWidth] - 100) / 2, 190.0f, 100.0f, 20.0f)];
        [pageControl_ addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventTouchUpInside];
        pageControl_.numberOfPages = 99 / 28 + 1;
        pageControl_.currentPage = 0;
        [self addSubview:pageControl_];
    }
    return self;
}

#pragma  mark --- event
- (void)btnPressed:(id)sender
{
    int i = ((UIButton *)sender).tag - iTag_;
    if(self.facedelegate && [self.facedelegate respondsToSelector:@selector(faceclickAtIndex:)])
    {
        [self.facedelegate faceclickAtIndex:i];
    }
}

- (void)pageChanged:(id)sender
{
    [scrView_ setContentOffset:CGPointMake(pageControl_.currentPage * 320.0f, 0.0f) animated:YES];
    [pageControl_ setCurrentPage:pageControl_.currentPage];
}

#pragma mark --- scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [pageControl_ setCurrentPage:scrView_.contentOffset.x / 320.0f];
    [pageControl_ updateCurrentPageDisplay];
}



@end


@implementation GrayPageControl



- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        activeImage = [UIImage imageNamed:@"page_image.png"];
        inactiveImage = [UIImage imageNamed:@"inpage_image.png"];
        [self setCurrentPage:1];
    }
    return self;
}

- (void)updateDots
{
//    [self logNavBarInfo];
    for (int i = 0; i < [self.subviews count]; i++) {
        UIView *dotView = [self.subviews objectAtIndex:i];
        if(i == self.currentPage)
        {
            if([dotView isKindOfClass:[UIImageView class]])
            {
                UIImageView *img = (UIImageView *)dotView;
                [img setImage:activeImage];
            }
            else
            {
                [dotView setBackgroundColor:[UIColor whiteColor]];
            }
        }

        else
        {
            if([dotView isKindOfClass:[UIImageView class]])
            {
                UIImageView *img = (UIImageView *)dotView;
                [img setImage:inactiveImage];
            }
            else
            {
                [dotView setBackgroundColor:[UIColor grayColor]];
            }
        }
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

- (void)logSubviews:(UIView *)superview leve:(int)iLvl
{
    NSString *strPre = @"";
    for (int i = 0; i <= iLvl; i++) {
        strPre = [strPre stringByAppendingString:@"=="];
    }
    for (UIView *view in superview.subviews) {
        BBINFO(@"%@ -%@", strPre, view.debugDescription);
        [self logSubviews:view leve:iLvl + 1];
    }
}

- (void)logNavBarInfo
{
    //    [self logSubviews:self.view leve:1];
    [self logSubviews:self leve:1];
}

@end
