//
//  ContactViewController.m
//  bbnote
//
//  Created by bob on 7/3/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import "ContactViewController.h"
#import "BBSkin.h"  

@interface ContactViewController ()

@end

@implementation ContactViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton:NSLocalizedString(@"Setting", nil) action:nil];
    [self showTitle:NSLocalizedString(@"skin", nil)];
}


@end
