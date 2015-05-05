//
//  LockViewController.h
//  Zine
//
//  Created by bob on 11/12/13.
//  Copyright (c) 2013 aura marker stdio. All rights reserved.
//

#import "BBViewController.h"

@protocol LockViewDelegate <NSObject>

- (void)lockViewControllerDidCancle:(UIViewController *)viewcontroller;
- (void)lockViewControllerDidEnter:(UIViewController *)viewcontroller;

@end


@interface LockViewController : BBViewController

@property (nonatomic, assign) BOOL bPresented;
@property(nonatomic, weak)id<LockViewDelegate> lockViewDelegate;

@end
