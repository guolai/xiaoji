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

@interface PaperListView ()
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
        self.tableDataDelegate = [[QMTabViewDelegate alloc] init];
        
        self.arrayData = [NSMutableArray arrayWithCapacity:100];
        [self reloadLocalData:NO];
        
        self.tblView = [[UITableView alloc] initWithFrame:self.bounds];
        [self.tblView setShowsHorizontalScrollIndicator:NO];
        [self.tblView setShowsVerticalScrollIndicator:NO];
        [self.tblView setBackgroundView:nil];
        [self.tblView setBackgroundColor:[UIColor clearColor]];
        [self.tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tblView.tableHeaderView = [self tableHeaderView];
        self.tblView.tableFooterView = [self tableFootView];
        [self addSubview:self.tblView];
        [self.tabBar selectTitle:kShareLyricRecommend animate:NO];
        self.strSelectedTitle = kShareLyricRecommend;
    }
    return self;
}

- (void)rebuildAllData:(NSDictionary *)dic tabName:(NSArray *)arrayData
{
    [self removeTableAllConnection];
    [self reloadLocalData:NO];
    PhotoItem *selectedPhoto = nil;
    NSArray *array = [JsonHelper getArrayFromDictionary:dic forKey:kShareLyricRecommend];
    if(array.count > 0)
    {
        for (int i = 0; i < self.arrayData.count; i++)
        {
            QMImageListData *listData = [self.arrayData objectAtIndex:i];
            if(listData.strTitle == kShareLyricRecommend)
            {
                if (array.count > 0)
                {
                    listData.array = array;
                    BBAssetWrapper *wrapperRecommed = [ComHelper getObjectInArray:array byIndex:0 ofClassType:[BBAssetWrapper class] defaultValue:nil];
                    selectedPhoto = wrapperRecommed.photoItem;
                }
                else
                {
                    listData.array = [self getMyRecommedData];
                    BBAssetWrapper *wrapperRecommed = [ComHelper getObjectInArray:listData.array byIndex:0 ofClassType:[BBAssetWrapper class] defaultValue:nil];
                    selectedPhoto = wrapperRecommed.photoItem;
                }
            }
        }
    }
    for (PhotoTabItem *tabTiem in arrayData)
    {
        if ([tabTiem.strTabName isEqualToString:kShareLyricRecommend])
        {
            continue;
        }
        array = [JsonHelper getArrayFromDictionary:dic forKey:tabTiem.strTabName];
        if (array.count >0)
        {
            QMImageListData *data = [[QMImageListData alloc] init];
            data.strTitle = tabTiem.strTabName;
            data.array = array;
            data.strDes = tabTiem.strTabDes;
            [self.arrayData addObject:data];
        }
    }
    [self.tabBar removeAllTabs];
    for (int i = 0; i < self.arrayData.count;  i++) {
        QMImageListData *data = [self.arrayData objectAtIndex:i];
        [self.tabBar addBtns:data.strTitle];
    }
    [self.tabBar adjustBtnsFrame];
    
    PhotoSelectedInfo *photoSelectedInfo = [CiPaiManager shareInstance].photoSelectedInfo;
    if ([photoSelectedInfo.strTitle isEqualToString:kShareLyricRecommend] && photoSelectedInfo.nIndex < 0)
    {
        
    }
    else
    {
        if(selectedPhoto)
        {
            photoSelectedInfo.strTitle = kShareLyricRecommend;
            photoSelectedInfo.nIndex = 0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(qmsharePhotoListDidClick:object:)])
            {
                [self.delegate qmsharePhotoListDidClick:QMSharePhotoList_Image object:selectedPhoto];
            }
            self.strSelectedTitle = kShareLyricRecommend;
            
        }
        else if(![photoSelectedInfo.strTitle isEqualToString:kShareLyricMy])
        {
            photoSelectedInfo.strTitle = kShareLyricMy;
            photoSelectedInfo.nIndex = -1;
            self.strSelectedTitle = kShareLyricMy;
        }
    }
    [self reloadTableViewData];
    [self.tabBar selectTitle:photoSelectedInfo.strTitle animate:NO];
    //    else
    //    {
    //        NSAssert(false, @"");
    //    }
    
    
}

- (void)reloadLocalData:(BOOL)bSelect
{
    [self.arrayData removeAllObjects];
    QMImageListData *data = [[QMImageListData alloc] init];
    data.strTitle = kShareLyricRecommend;
    data.array = [self getMyRecommedData];
    [self.arrayData addObject:data];
    BBAssetWrapper *wrapperRecommed = [ComHelper getObjectInArray:data.array byIndex:0 ofClassType:[BBAssetWrapper class] defaultValue:nil];
    PhotoItem *selectedPhoto = wrapperRecommed.photoItem;
    
    
    BBAssetWrapper *wrapper = [self getDefaultAssetItem];
    
    data = [[QMImageListData alloc] init];
    data.strTitle = kShareLyricMy;
    data.array = [NSArray arrayWithObjects:wrapper, nil];
    [self.arrayData addObject:data];
    
    if (bSelect)
    {
        PhotoSelectedInfo *photoSelectedInfo = [CiPaiManager shareInstance].photoSelectedInfo;
        if(selectedPhoto)
        {
            photoSelectedInfo.strTitle = kShareLyricRecommend;
            photoSelectedInfo.nIndex = 0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(qmsharePhotoListDidClick:object:)])
            {
                [self.delegate qmsharePhotoListDidClick:QMSharePhotoList_Image object:selectedPhoto];
            }
            self.strSelectedTitle = kShareLyricRecommend;
        }
        else if(![photoSelectedInfo.strTitle isEqualToString:kShareLyricMy])
        {
            photoSelectedInfo.strTitle = kShareLyricMy;
            photoSelectedInfo.nIndex = -1;
            self.strSelectedTitle = kShareLyricMy;
        }
    }
    [self reloadTableViewData];
    [self.tabBar selectTitle:self.strSelectedTitle animate:NO];
}


- (UIView *)tableHeaderView
{
    CGFloat fHeight = 42;
    CGFloat fWidth = SCREEN_WIDTH;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, fHeight)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.arrayData.count;  i++) {
        QMImageListData *data = [self.arrayData objectAtIndex:i];
        [array addObject:data.strTitle];
    }
    
    CGRect rect = view.bounds;
    rect.size.height = 40;
    self.tabBar = [[QMTitleTabView alloc] initWithFrame:rect titles:array];
    __weak __typeof(self) weakself = self;
    self.tabBar.titleBarBlock = ^(NSString *strtitle)
    {
        weakself.strSelectedTitle = strtitle;
    };
    
    [view addSubview:self.tabBar];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 0.5)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [lineView setAlpha:0.1];
    [view addSubview:lineView];
    
    return view;
}

- (UIView *)tableFootView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [view setBackgroundColor:[UIColor clearColor]];
    _lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, 30)];
    [_lblDescription setTextColor:[UIColor whiteColor]];
    [_lblDescription setBackgroundColor:[UIColor clearColor]];
    [_lblDescription setTextAlignment:NSTextAlignmentLeft];
    [_lblDescription setFont:[ComHelper systemFontOfSize:12]];
    [_lblDescription setNumberOfLines:-1];
    [_lblDescription setText:@"版权说明"];
    _lblDescription.alpha = 0.6;
    _lblDescription.hidden = YES;
    [view addSubview:_lblDescription];
    return view;
}

- (void)reloadTableViewData
{
    [self removeTableAllConnection];
    for (int i = 0; i < self.arrayData.count;  i++)
    {
        QMImageListData *data = [self.arrayData objectAtIndex:i];
        if([data.strTitle isEqualToString:_strSelectedTitle])
        {
            if([data.strTitle isEqualToString:kShareLyricMy])
            {
                data.array = [self getMyTabData];
            }
            if (data.strDes)
            {
                self.lblDescription.text = data.strDes;
                self.lblDescription.hidden = NO;
            }
            else
            {
                self.lblDescription.hidden = YES;
            }
            self.tableDataDelegate.arrayData = data.array;
            self.tableDataDelegate.strTitle = _strSelectedTitle;
            self.tblView.dataSource = self.tableDataDelegate;
            self.tblView.delegate = self.tableDataDelegate;
            self.tableDataDelegate.delegate = self;
            [self.tblView reloadData];
            return;
        }
    }
}

- (void)setStrSelectedTitle:(NSString *)strSelectedTitle
{
    if(_strSelectedTitle != strSelectedTitle)
    {
        _strSelectedTitle = strSelectedTitle;
        if([_strSelectedTitle length] < 1)
        {
            return;
        }
        [self reloadTableViewData];
    }
    else if(_strSelectedTitle == kShareLyricMy)
    {
        [self reloadTableViewData];
    }
    
}

- (NSArray *)getMyTabData
{
    NSArray *arrayUsed = [[CiPaiManager shareInstance] getLaterestUsedPhotos];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:arrayUsed.count];
    
    [array  addObject:[self getDefaultAssetItem]];
    [array addObjectsFromArray:arrayUsed];
    return array;
}

- (NSArray *)getMyRecommedData
{
    NSArray *arrayBig = @[@"poster_bg.jpg", @"poster_bg_1.jpg", @"poster_bg_2.jpg", @"poster_bg_3.jpg", @"poster_bg_4.jpg", @"poster_bg_5.jpg", @"poster_bg_6.jpg", @"poster_bg_7.jpg", @"poster_bg_8.jpg", @"poster_bg_9.jpg"];
    NSArray *arraySml = @[@"poster_bg_small.jpg", @"poster_bg_1_small.jpg", @"poster_bg_2_small.jpg", @"poster_bg_3_small.jpg", @"poster_bg_4_small.jpg", @"poster_bg_5_small.jpg", @"poster_bg_6_small.jpg", @"poster_bg_7_small.jpg", @"poster_bg_8_small.jpg", @"poster_bg_9_small.jpg"];
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i <arrayBig.count; i++)
    {
        PhotoItem *item = [[PhotoItem alloc] init];
        item.strTitle = kShareLyricRecommend;
        item.type = PhotoItem_Image;
        item.strImgName = [arraySml objectAtIndex:i];
        item.strBigImgName = [arrayBig objectAtIndex:i];
        BBAssetWrapper *wrapper = [[BBAssetWrapper alloc] initWithPhotoItem:item];
        [retArray addObject:wrapper];
    }
    return retArray;
}

- (BBAssetWrapper *)getDefaultAssetItem
{
    PhotoItem *item = [[PhotoItem alloc] init];
    
    item.type = PhotoItem_Asset;
    item.strImgName = @"poster_asset";
    BBAssetWrapper *wrapper = [[BBAssetWrapper alloc] initWithPhotoItem:item];
    return wrapper;
}

- (void)qmPhotoTableViewDidClickTitle:(NSString *)strTitle object:(PhotoItem *)object
{
    QMSharePhotoListType listType = QMSharePhotoList_Max;
    if(PhotoItem_Asset == object.type)
    {
        listType = QMSharePhotoList_AssetsLibrary;
    }
    else
    {
        listType = QMSharePhotoList_Image;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(qmsharePhotoListDidClick:object:)])
    {
        [self.delegate qmsharePhotoListDidClick:listType object:object];
    }
    [self.tblView reloadData];
    
}




@end
