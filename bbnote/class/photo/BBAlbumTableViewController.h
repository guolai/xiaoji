//
//  BBAlbumViewController.h
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBViewController.h"

@class BBAssetPikerState;
@interface BBAlbumTableViewController : UITableViewController
@property (nonatomic, weak) BBAssetPikerState *assetPickerState;
@end
