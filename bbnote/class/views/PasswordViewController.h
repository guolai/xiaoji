//
//  PasswordViewController.h
//  Zine
//
//  Created by bob on 11/12/13.
//  Copyright (c) 2013 aura marker stdio. All rights reserved.
//

#import "BBViewController.h"


@protocol PasswordViewControllerDelegate <NSObject>

- (void)PasswordViewControllerDidCancle:(UIViewController *)viewcontroller;
- (void)PasswordViewDidSetPassword:(UIViewController *)viewcontorller;

@end

@interface PasswordViewController : BBViewController

@property(nonatomic, weak)id<PasswordViewControllerDelegate> passwordDelegate;

@end
