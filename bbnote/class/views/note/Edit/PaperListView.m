//
//  PaperListView.m
//  bbnote
//
//  Created by bob on 10/18/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import "PaperListView.h"
#import "BBTableDelegate.h"
#import "BBAssetWrapper.h"
#import "BBTableDelegate.h"
#import "DataModel.h"

@interface PaperListView ()<BBPaperListDelegate>
@property (nonatomic, strong) UITableView *tblView;
@property (nonatomic, strong) BBTableDelegate *tableDataDelegate;
@property (nonatomic, strong) NSMutableArray *arrayData;
@end

@implementation PaperListView
- (void)dealloc
{
    [self removeTableAllConnection];
    self.tableDataDelegate = nil;
}

- (void)removeTableAllConnection
{
    [self.tableDataDelegate removeAllConnection];
    self.tblView.dataSource = nil;
    self.tblView.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.tableDataDelegate = [[BBTableDelegate alloc] init];
        
        self.arrayData = [NSMutableArray arrayWithCapacity:100];
    
        self.tblView = [[UITableView alloc] initWithFrame:self.bounds];
        [self.tblView setShowsHorizontalScrollIndicator:NO];
        [self.tblView setShowsVerticalScrollIndicator:NO];
        [self.tblView setBackgroundView:nil];
        [self.tblView setBackgroundColor:[UIColor clearColor]];
        [self.tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:self.tblView];
        [self reloadLocalData];
    }
    return self;
}

- (void)reloadLocalData
{
    [self.arrayData removeAllObjects];
    [self.arrayData addObjectsFromArray:[self getImagePaper]];
    [self.arrayData addObjectsFromArray:[self getColorPaper]];

    self.tableDataDelegate.arrayData = self.arrayData;
    self.tblView.dataSource = self.tableDataDelegate;
    self.tblView.delegate = self.tableDataDelegate;
    self.tableDataDelegate.delegate = self;
    [self.tblView reloadData];

}

- (BBAssetWrapper *)getImagePaperItem:(NSString *)strName
{
    if (!strName)
    {
        NSParameterAssert(false);
        return nil;
    }
    PaperItem *item = [[PaperItem alloc] init];
    item.paperType = Paper_Picture;
    item.strName = strName;
    BBAssetWrapper *wrapper = [[BBAssetWrapper alloc] initWithPhotoItem:item];
    return wrapper;
}

- (NSArray *)getImagePaper
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[self getImagePaperItem:@"skindefault.jpg"]];
    for (int i = 1; i <= 7; i++)
    {
        NSString *str = [NSString stringWithFormat:@"skin%d-down.jpg", i];
        [array addObject:[self getImagePaperItem:str]];
    }
    for (int i = 1; i <= 3; i++) {
        NSString *str = [NSString stringWithFormat:@"skin%d.png", i];
        [array addObject:[self getImagePaperItem:str]];
    }
    for (int i = 1; i <= 7; i++)
    {
        NSString *str = [NSString stringWithFormat:@"%.2d.png", i];
        [array addObject:[self getImagePaperItem:str]];
    }
    for (int i = 1; i <= 7; i++)
    {
        NSString *str = [NSString stringWithFormat:@"%.2d.jpg", i];
        [array addObject:[self getImagePaperItem:str]];
    }
    return array;
}

- (BBAssetWrapper *)getColorPaperItem:(NSString *)strName
{
    if (!strName)
    {
        NSParameterAssert(false);
        return nil;
    }
    PaperItem *item = [[PaperItem alloc] init];
    item.paperType = Paper_Color;
    item.strName = strName;
    BBAssetWrapper *wrapper = [[BBAssetWrapper alloc] initWithPhotoItem:item];
    return wrapper;
}

- (NSArray *)getColorPaper
{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dic = [DataModel getColorsTable];
    for (int i = 24; i > 0; i--) {
        NSString *strcolor = [dic objectForKey:[NSString stringWithFormat:@"color%d", i]];
        [array addObject:[self getColorPaperItem:strcolor]];
    }
    return array;
}




//- (UIView *)tableHeaderView
//{
//    CGFloat fHeight = 42;
//    CGFloat fWidth = SCREEN_WIDTH;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, fHeight)];
//    [view setBackgroundColor:[UIColor clearColor]];
//    
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < self.arrayData.count;  i++) {
//        QMImageListData *data = [self.arrayData objectAtIndex:i];
//        [array addObject:data.strTitle];
//    }
//    
//    CGRect rect = view.bounds;
//    rect.size.height = 40;
//    self.tabBar = [[QMTitleTabView alloc] initWithFrame:rect titles:array];
//    __weak __typeof(self) weakself = self;
//    self.tabBar.titleBarBlock = ^(NSString *strtitle)
//    {
//        weakself.strSelectedTitle = strtitle;
//    };
//    
//    [view addSubview:self.tabBar];
//    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 0.5)];
//    [lineView setBackgroundColor:[UIColor whiteColor]];
//    [lineView setAlpha:0.1];
//    [view addSubview:lineView];
//    
//    return view;
//}
//
//- (UIView *)tableFootView
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
//    [view setBackgroundColor:[UIColor clearColor]];
//    _lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, 30)];
//    [_lblDescription setTextColor:[UIColor whiteColor]];
//    [_lblDescription setBackgroundColor:[UIColor clearColor]];
//    [_lblDescription setTextAlignment:NSTextAlignmentLeft];
//    [_lblDescription setFont:[ComHelper systemFontOfSize:12]];
//    [_lblDescription setNumberOfLines:-1];
//    [_lblDescription setText:@"版权说明"];
//    _lblDescription.alpha = 0.6;
//    _lblDescription.hidden = YES;
//    [view addSubview:_lblDescription];
//    return view;
//}
//


- (void)bbPhotoTableViewDidClick:(PaperItem *)object
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(bbPhotoTableViewDidClick:)])
    {
        [self.delegate bbPhotoTableViewDidClick:object];
    }
    [self.tblView reloadData];
    
}




@end
