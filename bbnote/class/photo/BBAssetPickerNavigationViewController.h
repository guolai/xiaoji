//
//  BBAssetPickerNavigationViewController.h
//  Zine
//
//  Created by bob on 10/9/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import "BBNavigationViewController.h"
#import "BBAssetPikerState.h"

@protocol BBPresentViewControlerDelegate;


@interface BBAssetPickerNavigationViewController : BBNavigationViewController

@property (nonatomic, assign) BBAssetPikerType type;
@property (nonatomic, copy) NSString *strNotePath;
- (id)initWithDelegate:(id<BBPresentViewControlerDelegate>)presentDelagate;
- (id)initWithForSmartCardViewDelegate:(id<BBPresentViewControlerDelegate>)delegate;

@end


