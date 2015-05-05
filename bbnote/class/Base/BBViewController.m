//
//  BBViewController.m
//  Zine
//
//  Created by bob on 13-9-13.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import "BBViewController.h"

@interface BBViewController ()

@end

@implementation BBViewController

@synthesize width;
@synthesize height;
@synthesize navBarHeight;
@synthesize HUD;


- (void)dealloc
{
    [self removeHUD];

}

- (id)init
{
    if(self = [super init])
    {
        self.width = [[UIScreen mainScreen] bounds].size.width;
        self.height = [[UIScreen mainScreen] bounds].size.height;
        if(OS_VERSION - 7.0 >= 0)
        {
            self.navBarHeight = 64.0f;
        }
        else
            self.navBarHeight = 44.0f;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    BBDEALLOC();
    [super didReceiveMemoryWarning];
    if(OS_VERSION >= 6.0)
    {
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[BBSkin shareSkin].bgColor];
     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismissProgressHUD];
    [super viewWillDisappear:animated];
}

- (void)showProgressHUD
{
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.labelText = nil;
    self.HUD.delegate = self;
    [self.HUD show:YES];
    
}

- (void)showProgressHUDWithStr:(NSString *)str
{
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    // HUD.delegate = self;
    self.HUD.labelText = str;
    [self.HUD show:YES];
}

- (void)showProgressHUDWithDetail:(NSString *)str hideafterDelay:(float)idelay
{
    self.HUD.mode = MBProgressHUDModeText;
    //HUD.delegate = self;
    self.HUD.labelText = nil;
    self.HUD.detailsLabelText = str;
    [self.HUD show:YES];
    [self performSelector:@selector(dismissProgressHUD) withObject:nil afterDelay:idelay];
}

- (void)showProgressHUDWithStr:(NSString *)str hideafterDelay:(float)idelay
{
    self.HUD.mode = MBProgressHUDModeText;
    //HUD.delegate = self;
    self.HUD.labelText = str;
    [self.HUD show:YES];
    [self performSelector:@selector(dismissProgressHUD) withObject:nil afterDelay:idelay];
//    double delayInSeconds = idelay;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self removeHUD];
//    });
}

- (void)dismissProgressHUD
{
//    [self.HUD hide:NO];
    [self removeHUD];
}

- (void)removeHUD
{
    [_HUD removeFromSuperview];
	_HUD = nil;
}

- (void)setHUDProgress:(float)fvalue
{
    self.HUD.progress = fvalue;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
    [self removeHUD];
}

- (MBProgressHUD *)HUD
{
    if(!_HUD)
    {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
    }
    return _HUD;
}

#pragma mark orientation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
//
//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}

- (BOOL)isSupportSwipePop {
    return NO;
}


@end
