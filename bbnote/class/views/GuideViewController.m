//
//  GuideViewController.m
//  jyy
//
//  Created by bob on 3/16/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController ()<UIScrollViewDelegate>
{
    int _iAllPages;
    UIPageControl *_pageControl;
    
}

@end

@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view = view;
    
    _iAllPages = 1;
    
    
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    scrView.contentSize = CGSizeMake(self.width * _iAllPages, self.height);
    scrView.pagingEnabled = YES;
    scrView.showsHorizontalScrollIndicator = NO;
    scrView.showsVerticalScrollIndicator = NO;
    scrView.delegate = self;
    [self.view addSubview:scrView];

    NSArray *array = @[[UIImage imageNamed:@"guide1"]/*, [UIImage imageNamed:@"guide2"]*/];
    for (int i = 0; i < _iAllPages; i++) {
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * i, 0, self.width, self.height)];
        [imgview setImage:[array objectAtIndex:i]];
        [imgview setContentMode:UIViewContentModeCenter];
        [scrView  addSubview:imgview];
        if(i == _iAllPages - 1)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 95, self.height - 120, 190, 49)];
//            [btn  setBackgroundColor:[UIColor purpleColor]];
            [btn setImage:[UIImage imageNamed:@"btnstart"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [imgview setUserInteractionEnabled:YES];
            [imgview addSubview:btn];
        }
    }
    
    _pageControl = [[UIPageControl alloc] init];
    [_pageControl setFrame:CGRectMake(self.view.center.x - 10, self.height - 40, 20, 20)];
    _pageControl.numberOfPages = _iAllPages;
    _pageControl.currentPage = 0;
    [self.view addSubview:_pageControl];
    
}


#pragma mark - event

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGPoint offset = scrollView.contentOffset;
	int iPage = (int)(offset.x / self.width) % _iAllPages;
	_pageControl.currentPage = iPage;
}

- (void)btnPressed:(id)sender
{
    BBLOG();
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate showHomeView];
}

@end
