//
//  SelectBgViewController.h
//  bbnotes
//
//  Created by bob on 5/27/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BBViewController.h"

@interface SelectBgViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSArray *arrayData_;
}

@property(nonatomic, retain) UITableView *tableView;
@end
