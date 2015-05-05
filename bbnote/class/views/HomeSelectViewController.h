//
//  HomeSelectViewController.h
//  bbnote
//
//  Created by bob on 7/7/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBViewController.h"

@interface HomeSelectViewController : BBViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSArray *arrayData_;
}

@property(nonatomic, retain) UITableView *tableView;
@end
