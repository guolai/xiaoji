//
//  PullToRefreshView.h
//  bbnote
//
//  Created by Apple on 13-4-30.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"


@protocol BBViewControlerLoadMoreDelegate;

@interface PullToRefreshView : UITableView
{
    BOOL _loading;
}
@property (nonatomic, assign) id<BBViewControlerLoadMoreDelegate> loadMoreDelegate;
@property (nonatomic, assign) BOOL loading;
@end

@protocol BBViewControlerLoadMoreDelegate <NSObject>
-(void) doRefresh;
-(void) loadMore;
@end


