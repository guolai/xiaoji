//
//  BBNavigationViewController.m
//  Zine
//
//  Created by bob on 13-9-13.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import "BBNavigationViewController.h"
#import "BBSkin.h"


@interface BBNavigationViewController ()

@end

@implementation BBNavigationViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if(OS_VERSION >= 7.0)
        self.navigationBar.translucent = YES;
    else
    {
        self.navigationBar.translucent = NO;
    }
    [self changNavBarStyle];
    self.navigationBar.barStyle = UIBarStyleDefault;
//    self.navigationBar.translucent = NO;
//    self.navigationBar.tintColor= [BBSkin shareSkin].titleColor;
    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (void)changNavBarStyle
{
    [self logNavBarInfo];
    EBBSKIN_TYPE type = [BBSkin shareSkin].skinType;
    if(type <= eSkin_White)
    {
         NSString *strNavImg = [NSString stringWithFormat:@"navbar_bg_light%d", type];
        if(OS_VERSION >= 7.0)
        {
            if(type == eSkin_Black)
            {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }
            else
            {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }
            [self.navigationBar setBackgroundImage:[[UIImage imageNamed:strNavImg] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        }
        else
        {
            [self.navigationBar setBackgroundImage:[[UIImage imageNamed:strNavImg] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forBarMetrics:UIBarMetricsDefault];
        }
    }
    else
    {
        if(OS_VERSION >= 7.0)
        {
            if(type == eSkin_BlueSky /*|| type == eSkin_PinkNote || type == eSkin_GreenLeaf*/)
            {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }
            else
            {
                 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }
             NSString *strNavImg = [NSString stringWithFormat:@"navbar_bg_light%d_os7", type];
            [self.navigationBar setBackgroundImage:[[UIImage imageNamed:strNavImg] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        }
        else
        {
             NSString *strNavImg = [NSString stringWithFormat:@"navbar_bg_light%d", type];
            [self.navigationBar setBackgroundImage:[[UIImage imageNamed:strNavImg] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forBarMetrics:UIBarMetricsDefault];
        }
    }
    for (UIView *view in self.navigationBar.subviews) {
        if([view.debugDescription rangeOfString:@"UINavigationBarBackground"].location != NSNotFound)
        {
            for (UIView *subView in view.subviews) {
                if([subView.debugDescription rangeOfString:@"UIImageView"].location != NSNotFound)
                {
                    if(OS_VERSION >= 7.0)
                    {
                        subView.hidden = YES;
//                        subView.alpha = .0f;
                    }
                    
                    else
                    {
                        subView.hidden = NO;
//                        subView.alpha = 1.f;
                    }
                    
                }
            }
        }
    }

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
//    [self logSubviews:self.navigationBar leve:1];
}
@end

