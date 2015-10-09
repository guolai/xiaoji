//
//  AppDelegate.m
//  helpevernote
//
//  Created by bob on 4/8/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "GuideViewController.h"
#import "BBNavigationViewController.h"
#import "BBUserDefault.h"
#import "EvernoteSDK.h"
#import "MobClick.h"
#import "DataModel.h"
//#import "ShareWeibo.h"
#import "FileManagerController.h"

@implementation AppDelegate
@synthesize lockViewController;
@synthesize window;

- (void)showHomeView
{
    HomeViewController *vc = [[HomeViewController alloc] init];
    BBNavigationViewController *nav = [[BBNavigationViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}

- (void)showGuidView
{
    GuideViewController *vc = [[GuideViewController alloc] init];
    self.window.rootViewController = vc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:UMENGKEY];
    [BBAutoSize reGetScreenSize];
    

    BBINFO(@"%@", [FileManagerController libraryPath]);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UIView *loadingView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window addSubview:loadingView];


    if([BBUserDefault isFirstLaunchIn])
    {
        [self showGuidView];
    }
    else
    {
    
        [DataModel recoverCrashNote];//恢复crash后的note
        if(0)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [imgView setImage:[UIImage imageNamed:@"Default-568h.png"]];
            [loadingView  addSubview:imgView];
            NSMutableArray *arrayFrames = [[NSMutableArray alloc] init];
            for (int i = 0; i < 15; i++)
            {
                //            NSString *strFileName = [NSString stringWithFormat:@"loading_%d.png", i + 1];
                UIImage *temImg = [UIImage imageNamed:@"loading_1.png"];
                [arrayFrames addObject:temImg];
            }
            
            NSLog(@"%@", arrayFrames);
            UIImageView *animtView = [[UIImageView alloc] init];
            [animtView setFrame:CGRectMake(185, 369, 128, 77)];
            animtView.animationImages = arrayFrames;
            animtView.animationDuration = 2.0;
            animtView.animationRepeatCount = 1;
            [loadingView addSubview:animtView];
            [animtView startAnimating];
        }
        [self showHomeView];
        //            [self showGuidView];
    }
    [loadingView removeFromSuperview];
   

    [self.window makeKeyAndVisible];
    [self showProtectViewCtl];
    _bShouldLockScreenGetFocus = YES;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    _bShouldLockScreenGetFocus = NO;
    if([BBUserDefault isOpenedProtect])
    {
        if(!self.lockViewController)
        {
            self.lockViewController = [[LockViewController alloc] init];
            self.lockViewController.lockViewDelegate = self;
        }
        if(self.lockViewController.bPresented)
        {
            
        }
        else
        {
            UIViewController *uiviewcontontoller = self.window.rootViewController;
            while (uiviewcontontoller.presentedViewController) {
                uiviewcontontoller = uiviewcontontoller.presentedViewController;
            }
            __weak typeof(UIViewController*) weakvc = uiviewcontontoller;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakvc presentViewController:self.lockViewController animated:NO completion:Nil];
            });
        }
    }
    
}

- (void)showProtectViewCtl
{
    if ([BBUserDefault isOpenedProtect] )
    {
        if(!self.lockViewController) {
            self.lockViewController = [[LockViewController alloc] init];
            self.lockViewController.lockViewDelegate = self;
            [self.lockViewController getFocus:YES];
            [self.window.rootViewController  presentViewController:self.lockViewController animated:NO completion:Nil];
            _bShouldLockScreenGetFocus = YES;
        }
    }
    else
    {
        if (self.lockViewController)
        {
            [self.lockViewController getFocus:YES];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _bShouldLockScreenGetFocus = YES;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   
//        _bgTask = [application beginBackgroundTaskWithExpirationHandler:^{ //如果没有task，立即调用handler，否则10分钟后调用
//            if (_bgTask != UIBackgroundTaskInvalid)
//            {
//                @try {
//                    [application endBackgroundTask:_bgTask];
//                    //bgTask = UIBackgroundTaskInvalid;
//                    BBINFO(@"QQMusic在后台运行被杀掉了。剩余可运行时间=%.1f", application.backgroundTimeRemaining);
//                }
//                @catch (NSException * e) {
//                    BBINFO(@"EndBackgroundTask excepton:%@",[e reason]);
//                }
//            };}];
//        if (_bgTask != UIBackgroundTaskInvalid) {
//            BBINFO(@"background task began");
//        }
//    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [self.lockViewController getFocus:_bShouldLockScreenGetFocus];
    if(!_bShouldLockScreenGetFocus)
    {
        [self lockViewControllerDidEnter:self.lockViewController];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
//    [[ShareWeibo shareInstance] openUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BBINFO(@"%@", url.absoluteString);

//    [[ShareWeibo shareInstance] openUrl:url];
    return YES;
 
}

#pragma mark --- lockviewDelegate
- (void)lockViewControllerDidCancle:(UIViewController *)viewcontroller
{
    [self.lockViewController dismissViewControllerAnimated:NO completion:NULL];
    self.lockViewController = nil;
    [BBUserDefault setProtectPasswrod:nil];
    
}

- (void)lockViewControllerDidEnter:(UIViewController *)viewcontroller
{
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [viewcontroller   dismissViewControllerAnimated:NO completion:Nil];
    });
    self.lockViewController.bPresented = NO;
}


@end
