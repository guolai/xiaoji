//
//  DateViewController.h
//  BPM-iphone
//
//  Created by zhuhb on 12-11-8.
//  Copyright (c) 2012年 zhuhb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBViewController.h"
@interface DateViewController : BBViewController
{
    UIButton *btnStartDate_;
    UIButton *btnStartTime_;
    int iCurrentBtn_;
}
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, weak) id<BBPresentViewControlerDelegate>delegate;
@end
