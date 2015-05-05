//
//  AboutMeViewController.m
//  jyy
//
//  Created by bob on 3/6/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController


- (void)viewDidLoad
{
    NSString *strFilePath = [[NSBundle mainBundle] pathForResource:@"abouthospital" ofType:@"txt"];
    self.strContent = [NSString stringWithContentsOfFile:strFilePath encoding:NSUTF8StringEncoding error:nil];
    [super viewDidLoad];
    [self showTitle:NSLocalizedString(@"医院简介", nil) ];
    [self showBackButton:nil action:nil];
}


@end
