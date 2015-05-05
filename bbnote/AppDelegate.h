//
//  AppDelegate.h
//  helpevernote
//
//  Created by bob on 4/8/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, LockViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LockViewController *lockViewController;
- (void)showHomeView;
- (void)showGuidView;
@end
