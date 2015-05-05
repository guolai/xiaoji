//
//  PullToRefreshView.m
//  bbnote
//
//  Created by Apple on 13-4-30.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "PullToRefreshView.h"
#import "Constant.h"


@interface PullToRefreshView ()

@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, retain) EGORefreshTableFooterView *loadMoreFooterView;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@end


@implementation PullToRefreshView
@synthesize refreshHeaderView;
@synthesize loadMoreFooterView;
@synthesize refreshControl;
@synthesize loadMoreDelegate;

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTableDelegateDidScroll object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTableDelegateEndDraging object:nil];
    self.refreshControl = nil;
    self.refreshHeaderView = nil;
    self.loadMoreFooterView = nil;
    self.loadMoreDelegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.loading = NO;
        
        if(NSClassFromString(@"UIRefreshControl")) {
            
            self.refreshControl = [[UIRefreshControl alloc] init];
            [self.refreshControl addTarget:self action:@selector(refreshedByPullingTable:) forControlEvents:UIControlEventValueChanged];
        }
        else {
            
            self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
            
            self.refreshHeaderView.keyNameForDataStore = [NSString stringWithFormat:@"%@_LastRefresh", [self class]];
//            self.tableView.showsVerticalScrollIndicator = YES;
//            [self.tableView addSubview:self.refreshHeaderView];
            [self addSubview:self.refreshHeaderView];
        }
        self.loadMoreFooterView  = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, frame.size.height)];
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidEndDraggingNT:) name:kTableDelegateEndDraging object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidScrollNT:) name:kTableDelegateDidScroll object:nil];
    }
    return self;
}

#pragma mark --- delegate


- (void)scrollViewDidScrollNT:(NSNotification *)nt
{
    //if(self.searchDisplayController.searchResultsTableView == scrollView) return;
    UIScrollView *scrollView = [nt.userInfo objectForKey:@"scrollview"];
	if (self.refreshHeaderView.state == EGOOPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
	} else if (scrollView.isDragging) {
        if (self.refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !self.loading) {
			[self.refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (self.refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !self.loading) {
			[self.refreshHeaderView setState:EGOOPullRefreshPulling];
		}
        
        if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
    }
}

- (void)scrollViewDidEndDraggingNT:(NSNotification *)nt
{
    //if(self.searchDisplayController.searchResultsTableView == scrollView) return;
	 UIScrollView *scrollView = [nt.userInfo objectForKey:@"scrollview"];
    if (scrollView.contentOffset.y <= - 65.0f && !self.loading) {
        self.loading = YES;
        
		[self.refreshHeaderView setState:EGOOPullRefreshLoading];
		[self reloadData];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
        if(self.loadMoreDelegate && [self.loadMoreDelegate respondsToSelector:@selector(doRefresh)])
        {
            [self.loadMoreDelegate doRefresh];
        }
	}
    else if(1)
    {
        if (self.loadMoreDelegate && [self.loadMoreDelegate respondsToSelector:@selector(loadMore)]) {
            [self.loadMoreDelegate loadMore];
        }
    }
}

-(void) refreshedByPullingTable:(id) sender {
    
    [self.refreshControl beginRefreshing];
    if(self.loadMoreDelegate && [self.loadMoreDelegate respondsToSelector:@selector(doRefresh)])
    {
        [self.loadMoreDelegate doRefresh];
    }
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.refreshControl endRefreshing];
    });
}


-(void) setLoading:(BOOL)loading
{
    _loading = loading;
    
    [UIView beginAnimations:nil context:NULL];
    
    if(loading)
    {
        [self.refreshHeaderView setState:EGOOPullRefreshLoading];
        [UIView setAnimationDuration:0.2];
		self.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    }
    else
    {
        [self.refreshHeaderView setState:EGOOPullRefreshNormal];
        [self.refreshHeaderView setCurrentDate];
        
        [UIView setAnimationDuration:.3];
        [self setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    }
    [UIView commitAnimations];
}

#pragma mark ---observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    CGRect frame = loadMoreFooterView.frame;
    CGSize contentSize = self.contentSize;
    frame.origin.y = contentSize.height < self.frame.size.height ? self.frame.size.height : contentSize.height;
    loadMoreFooterView.frame = frame;
//    if (self.autoScrollToNextPage && _isFooterInAction) {
//        [self scrollToNextPage];
//        _isFooterInAction = NO;
//    } else if (_isFooterInAction) {
//        CGPoint offset = self.contentOffset;
//        offset.y += 44.f;
//        self.contentOffset = offset;
//    }
}

@end
