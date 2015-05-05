//
//  SmartCardViewController.m
//  Zine
//
//  Created by bob on 1/14/14.
//  Copyright (c) 2014 aura marker stdio. All rights reserved.
//

#import "SmartCardViewController.h"
#import "DataModel.h"
#import "BBUserDefault.h"
#import "FileManagerController.h"
#import "BBNavigationViewController.h"
#import "NSDate+String.h"
#import "TimeLimeCell.h"
#import "SmartCardCell.h"
#import "NSNumber+Sort.h"
#import "NSString+UUID.h"
#import "KTPhotoScrollViewController2.h"


@interface SmartCardViewController ()<BBRiefsTableViewCellDelegate>
{
    BOOL _bReachEnd;
    BOOL _bRefreshing;
    int _iCurYearMonth;
    NSArray *_arrayMonth;
    int _iStartIndex;
    int _iLimit;
}
@property (nonatomic, readonly) NSInteger briefsPerRow;
@property (nonatomic, strong) NSMutableDictionary *mulDic;
@property (nonatomic, strong) NSMutableSet *keySet;
@property (nonatomic, retain)UITableView *tblView;
@property (nonatomic, retain)NSMutableArray *arrayData;
@end

@implementation SmartCardViewController
@synthesize arrayData = _arrayData;
@synthesize tblView;
@synthesize briefsPerRow = _briefsPerRow;
@synthesize keySet;
- (void)dealloc
{
    BBDEALLOC();
    self.tblView = nil;
    self.arrayData = nil;
}



- (void)viewWillAppear:(BOOL)animated
{
    int iRet = [BBUserDefault getHomeViewIndex];
    if (iRet != 0)
    {
        [BBUserDefault setHomeViewIndex:0];
        dispatch_queue_t queue = dispatch_queue_create("com.auramarker.refresh", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshData];
            });
        });
    }
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self showBackButton:nil action:nil];
    [self showTitle:NSLocalizedString(@"Photos", nil)];
    self.arrayData = [NSMutableArray arrayWithCapacity:_iLimit];
    self.mulDic = [NSMutableDictionary dictionaryWithCapacity:100];
    self.keySet = [NSMutableSet setWithCapacity:100];
    _arrayMonth = [NSArray arrayWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];
    [self fetchData];
}

- (void)loadView
{
    _iStartIndex = 0;
    _iLimit = 8;
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    
    float viewHeight = self.height;
    
    float fTop = 0;
    if(OS_VERSION < 7.0)
    {
        viewHeight -= self.navBarHeight;
        viewHeight -= 20;
    }
    else
    {
        viewHeight -= self.navBarHeight;
        fTop += self.navBarHeight;
    }
    
//    float viewHeight = self.height;
//    
//    float fTop = 0;
//    if(OS_VERSION < 7.0)
//    {
//        viewHeight -= self.navBarHeight;
//        viewHeight -= 20;
//    }
//    else
//    {
////        viewHeight -= 20;
//    }
    
    self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, fTop, self.width, viewHeight) style:UITableViewStylePlain];
    self.tblView.separatorStyle = UITableViewCellAccessoryNone;
    if(OS_VERSION  >= 7.0)
    {
    }
    else
    {
        [self.tblView setBackgroundView:nil];
    }
    [self.tblView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[BBSkin shareSkin].bgColor];
    [self.view addSubview:self.tblView];
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    //  self.tblView.tableFooterView = self.loadMoreView;
}

- (void)resetData
{
    [self.arrayData removeAllObjects];
    [self.mulDic removeAllObjects];
    [self.keySet removeAllObjects];
    _iCurYearMonth = [[[NSDate date] getNumOfYearMonth] integerValue];
    _iCurYearMonth = _iCurYearMonth / 100 * 100;
    _iStartIndex = 0;
    _bReachEnd = NO;
    [self fetchData];
}

- (void)refreshData
{
    _bRefreshing = YES;
    _bReachEnd = NO;
    [self.arrayData removeAllObjects];
    [self.mulDic removeAllObjects];
    [self.keySet removeAllObjects];
    NSArray *array = [BBImage where:@"iscontent == NO" startFrom:0 limit:_iStartIndex + _iLimit sortby:@"create_date^0"];
    if(!array || array.count < 1)
    {
        _bReachEnd = YES;
    }
    else
    {
        if(array.count < _iStartIndex + _iLimit)
            _bReachEnd = YES;
        else
            _bReachEnd = NO;
        for (BBImage *bbime in array) {
            if([self.keySet containsObject:bbime.key])
            {
                
            }
            else
            {
                [self.keySet addObject:bbime.key];
                [self fetchSection:bbime];
            }
        }
        [self rebulidMenuData];
    }
    _bRefreshing = NO;
    [self tableviewReloadData];
    
}

- (void)fetchData
{
    if(_bRefreshing)
        return;
    NSArray *array = [BBImage where:@"iscontent == NO" startFrom:_iStartIndex limit:_iLimit sortby:@"create_date^0"];

    if(!array || array.count < 1)
    {
        _bReachEnd = YES;
        //[self.arrayData removeAllObjects];
    }
    else
    {
        if(array.count < _iLimit)
            _bReachEnd = YES;
        else
            _bReachEnd = NO;
        _iStartIndex += array.count;
        for (BBImage *bbime in array) {
      
            if([self.keySet containsObject:bbime.key])
            {
                
            }
            else
            {
                [self.keySet addObject:bbime.key];
                [self fetchSection:bbime];
            }
        }
        [self rebulidMenuData];
    }
    [self tableviewReloadData];
}

- (void)fetchSection:(BBImage *)bbimg
{
    NSString *strYearMonth = [bbimg.create_date getNumOfYearMonth];
    if(ISEMPTY(strYearMonth))
    {
        strYearMonth  = [[NSDate date] getNumOfYearMonth];
        NSAssert(false, @"canott be null");
        return;
    }
    NSMutableArray *tempArray = [self.mulDic objectForKey:strYearMonth];
    if(!tempArray)
    {
        tempArray = [NSMutableArray arrayWithCapacity:10];
    }
    SmartObject *smartObject = [[SmartObject alloc] init];
    BBRecord *record = bbimg.record;
    smartObject.strNotePath = [DataModel getNotePath:record];
    smartObject.strFileName = bbimg.data_path;
//    smartObject.strSmlFileName = bbimg.data_small_path;
    [tempArray addObject:smartObject];
    [self.mulDic setObject:tempArray forKey:strYearMonth];
}

- (void)rebulidMenuData
{
    [self.arrayData removeAllObjects];
    for (NSString *key in self.mulDic.allKeys) {
        BOOL bFind = NO;
        int iKey = [key integerValue];
        for (int i = 0; i < self.arrayData.count; i++) {
            NSString *strIndex = [self.arrayData objectAtIndex:i];
            int iIndex = [strIndex integerValue];
            if(iKey < iIndex)
            {
                
            }
            else if(iKey > iIndex)
            {
                [self.arrayData insertObject:key atIndex:i];
                bFind = YES;
                break;
            }
            else if(iKey == iIndex)
            {
                bFind  = YES;
                break;
            }
        }
        if(!bFind)
        {
            [self.arrayData addObject:key];
        }
    }
}

- (void)tableviewReloadData
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30 * fScr_Scale;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
 
    
    label.text = [self getTitleOfSection:section];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0 * fScr_Scale];
    label.textColor = [UIColor colorWithRed:35/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    [label setTextAlignment:NSTextAlignmentLeft];
    //    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.frame = CGRectMake( 40 / 2, 5,
                             [BBAutoSize screenWidth] - 40,
                             20 * fScr_Scale);
   	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [BBAutoSize screenWidth], 30 * fScr_Scale)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setAlpha:0.9];
	[view addSubview: label];
	return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self getCurrentArrayInSection:section];
    if(!array)
        return 0;
    int iTotal = array.count;
    if(section == self.arrayData.count - 1 && !_bReachEnd)
    {
        if(iTotal <= 2)
        {
            return 1 + 1;
        }
        else
        {
            iTotal += 1;
            return (iTotal + self.briefsPerRow - 1) / self.briefsPerRow  + 1;
        }
        
    }
    if(iTotal <= 2)
    {
        return 1;
    }
    else
    {
        iTotal += 1;
        return (iTotal + self.briefsPerRow - 1) / self.briefsPerRow;
    }
    
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)indexPath
{
    NSRange assetRange;
    if(indexPath.row == 0)
    {
        assetRange.location = 0;
        assetRange.length = 2;
    }
    else
    {
        assetRange.location = indexPath.row * self.briefsPerRow - 1;
        assetRange.length = self.briefsPerRow;
    }
    
    
    NSArray *array = [self getCurrentArrayInSection:indexPath.section];
    if(!array)
        return Nil;
    // Prevent the range from exceeding the array length.
    if (assetRange.length > array.count - assetRange.location) {
        assetRange.length = array.count - assetRange.location;
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:assetRange];
    
    // Return the range of assets from fetchedAssets.
    return [array objectsAtIndexes:indexSet];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self getCurrentArrayInSection:indexPath.section];
    if(!array || array.count < 1)
        return nil;
    if(!_bReachEnd && indexPath.section == self.arrayData.count - 1 && indexPath.row == (array.count + self.briefsPerRow - 1 + 1) / self.briefsPerRow)
    {
        static NSString *strCellIdent = @"ActivityCardCell";
        ActivityCell *actcell = [self.tblView dequeueReusableCellWithIdentifier:strCellIdent];
        if (actcell == nil)
        {
            actcell = [[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIdent];
        }
        [self fetchData];
        return actcell;
    }
    if(indexPath.row == 0)
    {
        static NSString *strCellIdentifier = @"SmartCardCell";
        SmartCardCell *cell = [self.tblView dequeueReusableCellWithIdentifier:strCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[SmartCardCell alloc] initWithReuseIdentifier:strCellIdentifier withColumn:2];
            cell.delegate = self;
        }
        
        [cell setCellCardViewsArray:[self assetsForIndexPath:indexPath]];
        return cell;
    }
    else
    {
        static NSString *strCellIdentifier = @"SmartCardCell2";
        SmartCardCell *cell = [self.tblView dequeueReusableCellWithIdentifier:strCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[SmartCardCell alloc] initWithReuseIdentifier:strCellIdentifier withColumn:3];
            cell.delegate = self;
        }
        
        [cell setCellCardViewsArray:[self assetsForIndexPath:indexPath]];
        return cell;
    }
    
}

- (NSArray *)getCurrentArrayInSection:(int)section
{
    NSString *strKey = [self.arrayData objectAtIndex:section];
    if(ISEMPTY(strKey))
        return 0;
    NSArray *array = [self.mulDic objectForKey:strKey];
    if(!array)
        return nil;
    return array;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *array = [self getCurrentArrayInSection:indexPath.section];
    if(!array || array.count < 1)
        return 0;
    if(indexPath.row == 0)
    {
        return roundf(160 * 480.0 * fScr_Scale / 320.0) + 1;
    }
    else
    {
        int iTotal = array.count;
        iTotal += 1;
        if(!_bReachEnd && indexPath.section == self.arrayData.count - 1 && indexPath.row == (iTotal + self.briefsPerRow - 1) / self.briefsPerRow)
        {
            return 40 * fScr_Scale;
        }
        return 480 * fScr_Scale / 3;
    }
    
}




#pragma  mark getter

- (NSString *)getTitleOfSection:(int)section
{
    NSString *strIndex = [self.arrayData objectAtIndex:section];
    NSString *strText = nil;
    int iCurrent = [strIndex integerValue];
    NSString *strIdentifer = NSLocalizedString(@"OK", nil);
    BOOL bChinese = YES;
    if(![strIdentifer isEqualToString:@"OK"])
    {
        bChinese = YES;
    }
    
    if(iCurrent - _iCurYearMonth < 0) //需要显示年
    {
        if(bChinese)
        {
            strText = [NSString stringWithFormat:@"%d年", iCurrent / 100];
            strText = [NSString stringWithFormat:@"%@ %d月", strText, iCurrent % 100];
        }
        else
        {
            NSString *strMonth = @"";
            int iMon = iCurrent % 100;
            if(iMon > 0 && iMon <= _arrayMonth.count)
            {
                strMonth = [_arrayMonth objectAtIndex:iMon - 1];
            }
            strText = [NSString stringWithFormat:@"%@ %d", strMonth,iCurrent / 100];
        }
    }
    else
    {
        if(bChinese)
        {
            strText = [NSString stringWithFormat:@"%d月", iCurrent % 100];
        }
        else
        {
            NSString *strMonth = @"";
            int iMon = iCurrent % 100;
            if(iMon > 0 && iMon <= _arrayMonth.count)
            {
                strMonth = [_arrayMonth objectAtIndex:iMon - 1];
            }
            strText = strMonth;
        }
        
    }
    return strText;
}

- (NSMutableArray *)arrayData
{
    if(!_arrayData)
    {
        _arrayData = [NSMutableArray arrayWithCapacity:10];
    }
    return _arrayData;
}

- (NSInteger)briefsPerRow
{
    return 3;
}

#pragma mark --- delegate photocell
- (void)smartcardTableViewCell:(SmartCardCell *)cell didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column
{

    NSIndexPath *indexPath = [self.tblView indexPathForCell:cell];
    NSArray *array = [self getCurrentArrayInSection:indexPath.section];
    // Calculate the index of the corresponding asset.
    NSUInteger assetIndex = indexPath.row * self.briefsPerRow + column;
    if(indexPath.row > 0)
    {
        assetIndex -= 1;
    }
    KTPhotoScrollViewController2 *vc = [[KTPhotoScrollViewController2 alloc] initWithImageArray:array andStartWithPhotoAtIndex:assetIndex andLocalFile:YES];
    vc.strTitle = [self getTitleOfSection:indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- sta
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)isSupportSwipePop {
    return YES;
}

#pragma mark -- presentviewcontroller callback delegate
- (void)presentViewCtrDidCancel:(UIViewController *)seder
{
    if(!self.view)
    {
        
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)presentViewCtrDidFinish:(UIViewController *)seder
{
    if(!self.view)
    {
        
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
