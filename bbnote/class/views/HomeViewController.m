//
//  HomeViewController.m
//  jyy
//
//  Created by bob on 1/6/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

////#import "RegistorViewController.h"
#import "BBMisc.h"
#import "TextCell.h"
#import "AboutMeViewController.h"
#import "MoreController.h"
#import "HomeTileView.h"
#import "HomeViewController.h"
#import "SettinViewController.h"
#import "TimeLineViewController.h"
#import "MediaViewController.h"
#import "NSDate+String.h"
#import "BB_BBImage.h"
#import "KTPhotoScrollViewController2.h"
#import "DataModel.h"
#import "SmartObject.h"
#import "SmartCardViewController.h"
#import "ImageCacheManager.h"
#import "BBUserDefault.h"

typedef enum{
    e_HomeBtn_1,
    e_HomeBtn_2,
    e_HomeBtn_3,
    e_HomeBtn_4,
    e_HomeBtn_btm1,
    e_HomeBtn_btm2,
    e_HomeBtn_btm3,
    e_HomeBtn_btm4
}T_HomeBtn;

@implementation HomeObject

@end

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    float _fOffset;
}
@property (nonatomic, strong) HomeTileView *homeTitleView;
@property (nonatomic, strong) UITableView *tblView;
@property (nonatomic, strong) NSArray *arrayData;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSArray *arrayIcons;
@property (nonatomic, strong) UIView *btnsView;
@property (nonatomic, strong) NSMutableArray *mulArray;
@property (nonatomic, strong) HomeObject *homeObject;
@property (nonatomic, strong) NSArray *arrayCount;
@end

@implementation HomeViewController
@synthesize homeTitleView;
@synthesize tblView;
@synthesize arrayData;
@synthesize footView = _footView;
@synthesize arrayIcons;
@synthesize btnsView;
@synthesize homeObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _bFirstIn = YES;
    self.homeObject = [[HomeObject alloc] init];
    self.arrayCount = @[@"0", @"0", @"0", @"", @"0", @"", @"", @""];
    [self reloadAllViews];
    self.arrayData = @[NSLocalizedString(@"Timeline", nil), NSLocalizedString(@"Photos", Nil), NSLocalizedString(@"Tags", Nil), NSLocalizedString(@"Calendar", Nil), NSLocalizedString(@"Starred", Nil), NSLocalizedString(@"Setting", Nil), NSLocalizedString(@"QQGroup", Nil)];
    
    self.arrayIcons = @[@(FAIconTh), @(FAIconPicture), @(FAIconTags), @(FAIconCalendar), @(FAIconStar), @(FAIconCog), @(FAIconCloud)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinDidChanged) name:kSkinDidChanged object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[ImageCacheManager shareInstance] clearCache];
    [super viewWillAppear:animated];
    [self rebulidMenu];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if(!_bFirstIn) //如果不是第一次进入，计算一下是不是要显示广告或者评价我们
    {
        [self rateUs];
    }
}

- (void)skinDidChanged
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self reloadAllViews];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _bFirstIn = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)reloadAllViews
{
    float viewHeight = self.height;
    float fTopHeight = 186 * fScr_Scale;
    float fTop = 0;
    if(OS_VERSION < 7.0)
    {
        //        viewHeight -= self.navBarHeight;
        viewHeight -= 20;
        fTopHeight -= 20;
    }
    else
    {
        fTop += 40;
        viewHeight -= 40;
        
    }
    viewHeight -= fTopHeight;
    _fOffset = fTop - self.width + fTopHeight;
    if(_fOffset > 0)
        _fOffset = 0;
    BBINFO(@"%f--- %f", self.width, self.height);
    self.homeTitleView = [[HomeTileView alloc] initWithFrame:CGRectMake(0, _fOffset, self.width, 320 * fScr_Scale)];
    
    fTop += fTopHeight;
    
    self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, fTop, self.width, viewHeight) style:UITableViewStylePlain];
    self.tblView.dataSource = self;
    self.tblView.delegate = self;
    [self.view addSubview:self.tblView];
    [self.view addSubview:self.homeTitleView];
    self.btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, fTop)];
    UIImage *btnImg = [UIImage imageNamed:@"home_camera"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:btnImg forState:UIControlStateNormal];
    CGRect rct = CGRectMake((self.width / 2 - btnImg.size.width) / 2, (fTop - btnImg.size.height) / 2, btnImg.size.width, btnImg.size.height);
    [btn setFrame:rct];
    [btn addTarget:self action:@selector(btnCameraPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnsView addSubview:btn];
    rct.origin.x += self.width / 2;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"home_add"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAddNewPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:rct];
    [self.btnsView addSubview:btn];
    [self.view addSubview:self.btnsView];
    
    
    if(OS_VERSION  >= 7.0)
    {
    }
    else
    {
        [self.tblView setBackgroundView:nil];
    }
    self.tblView.tableFooterView = self.footView;
    [self.tblView setShowsHorizontalScrollIndicator:NO];
    [self.tblView setShowsVerticalScrollIndicator:NO];
    [self.view setBackgroundColor:[BBSkin shareSkin].bgColor];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]]];
}

- (void)rebulidMenu
{
    NSArray *array = [BB_BBRecord where:nil startFrom:0 limit:99999 sortby:@"create_date^0"];
    NSMutableSet *mulSet = [NSMutableSet setWithCapacity:array.count];
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithCapacity:10];
    if(array.count < 1)
        return;
    for (BB_BBRecord *record in array) {
        if ([mulSet containsObject:record.key]) {
            
        }
        else if(!record.key)
        {
//            NSAssert(false, @"error");
            [record delete];
        }
        else
        {
            [mulSet addObject:record.key];
            NSString *strYearMonth = [record.create_date  getStringOfYearMonthDay];
//            BBINFO(@"%@", strYearMonth);
            if (ISEMPTY(strYearMonth)) {
                strYearMonth = [[NSDate date] getStringOfYearMonthDay];
            }
            NSMutableArray *tempArray = [mulDic objectForKey:strYearMonth];
            if(!tempArray)
            {
                tempArray = [NSMutableArray arrayWithCapacity:10];
            }
            [tempArray addObject:record];
            [mulDic setObject:tempArray forKey:strYearMonth];
        }
    }
    self.homeObject.nTotoal = mulSet.count;
    self.homeObject.nDayCount = mulDic.count;
    self.homeObject.nTheWeekCount = 0;
    NSArray *arrayDays = [[NSDate date] getWeekDays];
    for (NSString *strDay in arrayDays) {
        NSMutableArray *tempArray = [mulDic objectForKey:strDay];
        self.homeObject.nTheWeekCount += tempArray.count;
    }
    self.homeObject.nTheDayCount = 0;
    NSString *strYearMonth = [[NSDate date] getStringOfYearMonthDay];
    NSMutableArray *tempArray = [mulDic objectForKey:strYearMonth];
    self.homeObject.nTheDayCount = tempArray.count;
    
    array = [BB_BBImage where:@"iscontent == NO" startFrom:0 limit:99999 sortby:@"create_date^0"];
    self.homeObject.nPhotosCount = array.count;
    [self.homeTitleView setEntriesCount:self.homeObject.nTotoal];
    [self.homeTitleView setDaysCount:self.homeObject.nDayCount];
    [self.homeTitleView setWeeksCount:self.homeObject.nTheWeekCount];
    [self.homeTitleView setTodayCount:self.homeObject.nTheDayCount];
    self.arrayCount = @[[NSString stringWithFormat:@"%d", self.homeObject.nTotoal],
                        [NSString stringWithFormat:@"%d", self.homeObject.nPhotosCount],
                        [NSString stringWithFormat:@"%d", 0],
                        @"",
                        [NSString stringWithFormat:@"%d", 0],
                        @"",
                        @"",
                        @"",
                        @""];
    [self.tblView reloadData];
}



#pragma mark tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}


- (UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIImageView alloc] init];
        [_footView setBackgroundColor:[UIColor clearColor]];
        [_footView  setFrame:CGRectMake(0, 0, self.width, 36.0 * fScr_Scale)];
        [_footView setBackgroundColor:[UIColor clearColor]];
        UILabel *lbl = [[UILabel alloc] initWithFrame:_footView.bounds];
        [lbl setText:NSLocalizedString(@"The best assistant for evernote!", nil)];
        [lbl setTextColor:[BBSkin shareSkin].titleBgColor];
        [lbl setFont:[UIFont boldSystemFontOfSize:10 * fScr_Scale]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [_footView addSubview:lbl];
    }
    return _footView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.arrayData.count - 1)
        return 80.0;
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FAIcon iconType = [[self.arrayIcons objectAtIndex:indexPath.row] integerValue];
    if(indexPath.row < self.arrayData.count - 1)
    {
        static NSString *strCell = @"icontextCell";
        TextTableCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if(!cell)
        {
            cell = [[TextTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
            if(OS_VERSION < 7.0)
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        }
        cell.fontImg.bgViewColor = [UIColor clearColor];
        cell.fontImg.iconImgColor = [BBSkin shareSkin].titleBgColor;
        cell.fontImg.iconName = iconType;
        cell.lblName.text = [self.arrayData objectAtIndex:indexPath.row];
        cell.lblText.text = [self.arrayCount objectAtIndex:indexPath.row];
        cell.myaccessView.hidden = NO;

        return cell;
    }
    else
    {
        static NSString *strCell = @"textCell";
        EvernoteTableCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if(!cell)
        {
            cell = [[EvernoteTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        }
        cell.lblName.text = @"私密日记";
        cell.lblText.text = [self.arrayData objectAtIndex:indexPath.row];
        return cell;
    }

    return Nil;
}


#pragma mark table delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    @[NSLocalizedString(@"Timeline", nil), NSLocalizedString(@"Photos", Nil), NSLocalizedString(@"Tags", Nil), NSLocalizedString(@"Calendar", Nil), NSLocalizedString(@"Starred", Nil), NSLocalizedString(@"Setting", Nil), NSLocalizedString(@"iClound", Nil)];
    NSString *strTitle = [self.arrayData objectAtIndex:indexPath.row];
    if(ISEMPTY(strTitle))
        return;
    if([strTitle isEqualToString:NSLocalizedString(@"Timeline", nil)])
    {
        TimeLineViewController *vc = [[TimeLineViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([strTitle isEqualToString:NSLocalizedString(@"Photos", nil)])
    {
        if(self.homeObject.nPhotosCount < 1)
        {
            [self showProgressHUDWithDetail:NSLocalizedString(@"The Photos is Empty!", nil) hideafterDelay:2.0];
            return;
        }
        SmartCardViewController *vc = [[SmartCardViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([strTitle isEqualToString:NSLocalizedString(@"Tags", nil)])
    {
        [self showProgressHUDWithDetail:NSLocalizedString(@"The tags hadn't created!", nil) hideafterDelay:2.0];
        return;
    }
    else if([strTitle isEqualToString:NSLocalizedString(@"Calendar", nil)])
    {
        [self showProgressHUDWithDetail:NSLocalizedString(@"The feature will come soon!", nil) hideafterDelay:2.0];
        return;
    }
    else if([strTitle isEqualToString:NSLocalizedString(@"Starred", nil)])
    {
        [self showProgressHUDWithDetail:NSLocalizedString(@"The Starred hadn't created!", nil) hideafterDelay:2.0];
        return;
    }
    else if([strTitle isEqualToString:NSLocalizedString(@"Setting", nil)])
    {
        SettinViewController *vc = [[SettinViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([strTitle isEqualToString:NSLocalizedString(@"QQGroup", nil)])
    {
        
    }

}

#pragma mark -- event

- (void)btnAddNewPressed:(id)sender
{
    TextViewController *vc = [[TextViewController alloc] initWithNewNote];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnCameraPressed:(id)sender
{
    MediaViewController *vc = [[MediaViewController alloc] initWithNewNote];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - review us

- (void)rateUs
{
    { //评价计数
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        if(![userdefault objectForKey:@"system-version"])
        {
            NSString* strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            [userdefault setObject:strVersion forKey:@"system-version"];
            [userdefault setObject:[NSNumber numberWithInt:0] forKey:@"usetimes"];
            [userdefault synchronize];
        }
        float fVersion = [[userdefault objectForKey:@"system-version"] floatValue];
        NSNumber *nTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"usetimes"];
        int iTime = [nTime intValue];
        
        NSString* strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        float version = [strVersion floatValue];
        if(version == fVersion)
        {
            iTime ++;
            if(iTime == 10 || iTime == 20 || iTime == 30 || iTime == 40 || iTime == 50)
                //                if(iTime == 1 || iTime == 2 || iTime == 3 || iTime == 4 || iTime == 5)
                //                if (iTime > 2)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"Like it or not , please rate us!", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancle", nil)
                                                      otherButtonTitles:NSLocalizedString(@"Rate Us", nil), nil];
                [alert show];
            }
            [userdefault setObject:[NSNumber numberWithInt:iTime] forKey:@"usetimes"];
            [userdefault synchronize];
        }
        else if(version > fVersion)
        {
            [self removeRateUs];
        }
        else
        {
            [userdefault setObject:strVersion forKey:@"system-version"];
            [userdefault setObject:[NSNumber numberWithInt:0] forKey:@"usetimes"];
            [userdefault synchronize];
        }
    }
}

- (void)removeRateUs
{
    NSString* strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    float version = [strVersion floatValue];
    version += 0.01;
    strVersion = [NSString stringWithFormat:@"%f", version];
    [[NSUserDefaults standardUserDefaults] setObject:strVersion forKey:@"system-version"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"usetimes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Rate Us", Nil)])
    {
        [BBUserDefault removeRateUs];
        NSString *strMyid = [NSString stringWithFormat:
                             @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", MYAPPID];
        if(OS_VERSION >= 7.0)
        {
            strMyid = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/zine/id%@?ls=1&mt=8", MYAPPID];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strMyid]];
    }
    
}

@end
