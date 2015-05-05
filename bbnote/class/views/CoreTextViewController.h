//
//  CoreTextViewController.h
//  jyy
//
//  Created by bob on 3/6/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BBViewController.h"
@class FTCoreTextView;
@interface CoreTextViewController : BBViewController
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FTCoreTextView *coreTextView;
@property (nonatomic, strong) NSString *strContent;
@end
