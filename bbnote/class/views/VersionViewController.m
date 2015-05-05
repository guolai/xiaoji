//
//  VersionViewController.m
//  jyy
//
//  Created by bob on 3/23/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()

@end

@implementation VersionViewController

- (void)viewDidLoad
{
    NSString *strFilePath = [[NSBundle mainBundle] pathForResource:@"version" ofType:@"txt"];
    self.strContent = [NSString stringWithContentsOfFile:strFilePath encoding:NSUTF8StringEncoding error:nil];
    [super viewDidLoad];
    [self showTitle:NSLocalizedString(@"版本信息", nil) ];
    [self showBackButton:nil  action:nil];
}

@end
