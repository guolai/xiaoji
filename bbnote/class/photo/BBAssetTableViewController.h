//
//  BBAssetTableViewController.h
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBViewController.h"
#import "DeleteBtn.h"

@class ALAssetsGroup;
@class BBAssetPikerState;
@interface BBAssetTableViewController : BBViewController<UITableViewDataSource, UITableViewDelegate, SaveimageDelegate>

@property (nonatomic,retain)SelectedImageScrollView *scrView;
@property (nonatomic, weak)BBAssetPikerState *assetPickerState;
@property (nonatomic, weak)ALAssetsGroup *assetsGroup;
@end
