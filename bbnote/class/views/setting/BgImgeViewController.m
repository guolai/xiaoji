//
//  SkinViewController.m
//  bbnote
//
//  Created by zhuhb on 13-6-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BgImgeViewController.h"
#import "SelectView.h"
#import "BBUserDefault.h"
#import "DataManager.h"

@interface BgImgeViewController ()<SelectImageDelegate>
{
    SelectView *selctView_;
    NSMutableArray *mulArray_;
    BOOL bShouldReturn_;
}

@end

@implementation BgImgeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[BBSkin shareSkin].bgColor];
    [self showBackButton:NSLocalizedString(@"Home", nil)  action:nil];
    [self showTitle:NSLocalizedString(@"Setting",nil)];
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
    
    mulArray_ = [NSMutableArray arrayWithCapacity:16];
    [mulArray_ addObject:@"photo-detail-bg.jpg"];
    for (int i = 1; i <= 7; i++) {
        NSString *str = [NSString stringWithFormat:@"skin%d-down.jpg", i];
        [mulArray_ addObject:str];
    }
    for (int i = 1; i <= 3; i++) {
        NSString *str = [NSString stringWithFormat:@"skin%d.png", i];
        [mulArray_ addObject:str];
    }
    selctView_ = [[SelectView alloc] initWithFrame:CGRectMake(10, fTop, SCR_WIDTH - 20, viewHeight) withBgImages:mulArray_ cloumn:3];
    selctView_.selectDelegate = self;
    [self.view addSubview:selctView_];
    bShouldReturn_ = NO;
	[self selectDefaultColor];

}

- (void)selectDefaultColor
{
    NSString *strColor = [[DataManager ShareInstance] noteSetting].strBgImg;
    if(ISEMPTY(strColor))
    {
        return;
    }
    for (int i = 0; i < mulArray_.count; i++) {
        NSString *str = [mulArray_ objectAtIndex:i];
        if([strColor isEqualToString:str])
        {
            [selctView_  didSelectAColor:i];
            break;
        }
    }
    bShouldReturn_ = YES;
}
#pragma mark ---- SelectImageDelegate

- (void)didSelectAColor:(int )ivalue
{
    NSString *strClor = [mulArray_ objectAtIndex:ivalue];
    //BBINFO(@"%@", strClor);
    [[DataManager ShareInstance] noteSetting].strBgImg = strClor;
    if(bShouldReturn_)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

    }
}


@end
