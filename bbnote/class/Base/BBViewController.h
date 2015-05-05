//
//  BBViewController.h
//  Zine
//
//  Created by bob on 13-9-13.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+BackButton.h"
#import "MBProgressHUD.h"


@protocol BBPresentViewControlerDelegate <UINavigationControllerDelegate>

- (void)presentViewCtrDidCancel:(UIViewController *)seder;
- (void)presentViewCtrDidFinish:(UIViewController *)seder;
@optional
- (void)presentViewCtrDidCancelForWeibo:(UIViewController *)seder type:(int)type;
- (void)presentViewCtrDidFinishWithObject:(id)object;

@end

@protocol SwitchStateDelegate <NSObject>
@optional
- (void)shouleToggleStateChange:(UIViewController *)vc;
- (void)shouldToggleTapGesture:(BOOL)bValue inViewControler:(UIViewController *)vc;
@end

@interface BBViewController : UIViewController<MBProgressHUDDelegate>
{
    //    @private
    MBProgressHUD *_HUD;
}
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) float navBarHeight;
- (void)showProgressHUD;

- (void)showProgressHUDWithStr:(NSString *)str;

- (void)showProgressHUDWithStr:(NSString *)str hideafterDelay:(float)idelay;

- (void)showProgressHUDWithDetail:(NSString *)str hideafterDelay:(float)idelay;

- (void)dismissProgressHUD;
- (void)setHUDProgress:(float)fvalue;

@end
