//
//  SkinViewController.m
//  bbnote
//
//  Created by zhuhb on 13-6-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "SkinViewController.h"
#import "BBSkin.h"
#import "SelectView.h"
#import "BBNavigationViewController.h"

@interface SkinViewController ()<SelectImageDelegate>
{
    SelectView *selctView_;
}

@end

@implementation SkinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadAllViews];
  
}

- (void)loadView
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    
    float viewHeight = self.height;
    
    float fTop = 0;
    if(OS_VERSION < 7.0)
    {
        viewHeight -= self.navBarHeight;
        viewHeight -= 20;
    }
    else
    {
        viewHeight -= self.navBarHeight;
        fTop += self.navBarHeight;
    }
    NSMutableArray *mulArray = [NSMutableArray arrayWithCapacity:9];
    for (int i = 0; i <= 8; i++) {
        [mulArray addObject:[NSString stringWithFormat:@"skin_%i", i]];
    }
    selctView_ = [[SelectView alloc] initWithFrame:CGRectMake(10, fTop + 10, SCR_WIDTH - 20, 300) withSkinImages:mulArray cloumn:3];
    selctView_.selectDelegate = self;
    [self.view addSubview:selctView_];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self selectDefaultColor];
}

- (void)selectDefaultColor
{
     EBBSKIN_TYPE skintype = [BBSkin shareSkin].skinType;
    [selctView_ didChangeSkinType:skintype];
}
#pragma mark selectImageDelegate

- (void)didChangeSkinType:(int)ivalue
{
    [BBSkin shareSkin].skinType = ivalue;
    BBNavigationViewController *navVc = (BBNavigationViewController *)self.navigationController;
    [navVc changNavBarStyle];
    [self reloadAllViews];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSkinDidChanged object:nil];
}

- (void)reloadAllViews
{
    [self.view setBackgroundColor:[BBSkin shareSkin].bgColor];
//    [self showBackButton:NSLocalizedString(@"Setting", nil) style:e_Nav_Gray action:nil];
    [self showBackButton:NSLocalizedString(@"Setting", nil) action:nil];
}

@end
