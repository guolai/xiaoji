//
//  HomeViewController.h
//  bbnote
//
//  Created by Apple on 13-3-27.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewDelegate.h"
#import "PullToRefreshView.h"
#import "BBViewController.h"


@interface TimeLineViewController : BBViewController< BBViewControlerLoadMoreDelegate,UIActionSheetDelegate>
{    
    BOOL bFrist_;
    int iStartIndex_;
    int iLimit_;
}
@property (nonatomic, retain)PullToRefreshView *homeTableView;
@property (nonatomic, retain)TableViewDelegate *tableDelegate;
@property (nonatomic, retain) NSMutableArray *datalistArray;
@end
