//
//  HomeViewController.m
//  bbnote
//
//  Created by Apple on 13-3-27.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "TimeLineViewController.h"
#import "AppDelegate.h"
#import "BBSkin.h"
#import "BB_BBRecord.h"
#import "BContent.h"
#import "BB_BBContent.h"
#import "BB_BBImage.h"
#import "BB_BBAudio.h"
#import "FileManagerController.h"  
#import "BBMisc.h"
#import "NSNumber+Sort.h"
#import "KTPhotoScrollViewController.h"
#import "SettinViewController.h"
#import "SelectBgViewController.h"
#import "NSDate+String.h"
#import "BBUserDefault.h"
#import "NSString+UUID.h"
#import "UIImage+SCaleImage.h"
#import "DataModel.h"
#import "DataManager.h"
#import "HomeSelectViewController.h"
#import "RichEditViewController.h"
#import "BRecord.h"
#import "BLine.h"

@interface TimeLineViewController ()

@end

@implementation TimeLineViewController
@synthesize homeTableView;
@synthesize tableDelegate;
@synthesize datalistArray;
- (void)dealloc
{
    [self.homeTableView removeFromSuperview];
    self.homeTableView = nil;
    self.tableDelegate = nil;
    self.datalistArray = nil;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableviewDidSelect:) name:kTableDelegateDidSelect object:nil];
    int iRet = [BBUserDefault getHomeViewIndex];
    if (iRet != 0)
    {
        [BBUserDefault setHomeViewIndex:0];
        [self rebuildMenu];
        if(iRet > 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:iRet + 1 inSection:0];
            [self.homeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    BBLOG();
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTableDelegateDidSelect object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showTitle:NSLocalizedString(@"Micro diary", nil)];
    [self showBackButton:nil action:nil];
    [self showRigthButton:nil withImage:@"home_camera" highlightImge:nil andEvent:@selector(rightNavPressed:)];
    [self rebuildMenu];
}

- (void)loadView
{
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
//        viewHeight -= self.navBarHeight;
//        fTop += self.navBarHeight;
    }
    self.datalistArray = [NSMutableArray arrayWithCapacity:18];
    
    self.homeTableView = [[PullToRefreshView alloc] initWithFrame:CGRectMake(0, fTop, self.width, viewHeight)];
    self.homeTableView.separatorStyle = UITableViewCellAccessoryNone;
    if(OS_VERSION  >= 7.0)
    {
        [self.homeTableView setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.homeTableView setBackgroundColor:[UIColor clearColor]];
        [self.homeTableView setBackgroundView:nil];
    }
    [self.view addSubview:self.homeTableView];
    
    self.tableDelegate = [[TableViewDelegate alloc] initWithType:e_Tableview_Home];
    self.tableDelegate.arrayDataList = self.datalistArray;
    self.homeTableView.delegate = self.tableDelegate;
    self.homeTableView.dataSource = self.tableDelegate;
    self.homeTableView.loadMoreDelegate = self;
    [self firstTimeRun];
}


-(void)firstTimeRun
{
    if([BBUserDefault shouldCreateDemo])
    {

        BRecord *brecord = [[BRecord alloc] init];
        BContent *bContent = [[BContent alloc] init];
        NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:10];
        NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
        if(noteset.isUseBgImg)
        {
            brecord.bg_image = noteset.strBgImg;
            brecord.bg_color = noteset.strBgColor;
        }
        else
        {
            brecord.bg_image = nil;
            brecord.bg_color = noteset.strBgColor;
        }
        BB_BBRecord *bbrecord = [BB_BBRecord initWithBRecord:brecord];
        bbrecord.create_date = [NSDate getNoteBirthDay];
        NSString *strFloder = [DataModel getNotePath:bbrecord];
        
        NSArray *arrayText = @[@"用美妙的文字记录下此刻感想，用生动的图片定格青春的每一个精彩的瞬间，用声音缅怀那些曾经的青涩，", @"用美妙的文字记录下此刻感想，用生动的图片定格青春的每一个精彩的瞬间，用声音缅怀那些曾经的青涩，", @"用美妙的文字记录下此刻感想，用生动的图片定格青春的每一个精彩的瞬间，用声音缅怀那些曾经的青涩，", @"用美妙的文字记录下此刻感想，用生动的图片定格青春的每一个精彩的瞬间，用声音缅怀那些曾经的青涩，"];
        NSMutableString *string = [NSMutableString string];
        NSMutableArray *arrayLines = [NSMutableArray arrayWithCapacity:5];
        for (int i = 0; i < 4; i++)
        {
            NSString *strPath = [NSString stringWithFormat:@"record0%d.jpg", i];
            BBINFO(@"%@", strPath);
            UIImage *image = [UIImage imageNamed:strPath];
            ScaledBImage *scaleImage = [DataModel scaleImage:image];
        
            BImage *bimge = [[BImage alloc] init];
            bimge.create_date = [NSDate getNoteBirthDay];

            bimge.data_path = [NSString stringWithFormat:@"%@.jpg", bimge.key];
            [imgArray addObject:bimge];
            
            NSString *strOldPath = [[FileManagerController resourcesPath] stringByAppendingPathComponent:strPath];
            NSString *strNewPath = [strFloder stringByAppendingPathComponent:bimge.data_path];
            [FileManagerController copyItem:strOldPath toItem:strNewPath];
        
            BLine *bline = [[BLine alloc] init];
            bline.text = [arrayText objectAtIndex:i];
            bline.line = i * 3;
            bline.length = bline.text.length;
            [arrayLines addObject:bline];
            [string appendString:bline.text];
            
            bline = [[BLine alloc] init];
            bline.text = UNICODE_OBJECT_PLACEHOLDER;
            bline.displaySize = scaleImage.displaySize;
            bline.orgiSize = scaleImage.originalSize;
            bline.fileName = bimge.data_path;
            bline.line = i * 3 + 1;
            [arrayLines addObject:bline];
            [string appendString:bline.text];
            
            bline = [[BLine alloc] init];
            bline.text = @"\n";
            bline.line = i * 3 + 2;
            bline.length = bline.text.length;
            [arrayLines addObject:bline];
            [string appendString:bline.text];
        }
        bContent.text = string;
        bContent.arrayLine = arrayLines;
        
        for (int i = 0; i < imgArray.count; i++)
        {
            BImage *bime = [imgArray objectAtIndex:i];
            BB_BBImage *bbime = [BB_BBImage BBImageWithBImage:bime];
            bbime.record = bbrecord;
        }
        
        BB_BBText *bbcontent = [BB_BBText BBContentWithBContent:bContent];
        bbcontent.record = bbrecord;
        bbcontent.create_date = [NSDate getNoteBirthDay];
        bbcontent.modify_date = [NSDate getNoteBirthDay];
        bbrecord.contentInRecord = bbcontent;
        
        [bbrecord save];
    }
}


- (void)rebuildMenu
{
    bFrist_ = YES;
    iStartIndex_ = 0;
    iLimit_  = 10000;
    [self.datalistArray removeAllObjects];
    [self requestData];
}


- (void)requestData
{
    BOOL bShouldReload = NO;
    
    NSArray *array = [BB_BBRecord where:nil startFrom:iStartIndex_ limit:iLimit_ sortby:@"create_date^0"];
    //BBINFO(@"1111 %@", self.datalistArray);
    if(array.count > 0)
    {
        for (id record  in array) {
            BB_BBRecord *bbrecord = (BB_BBRecord *)record;
            //BBINFO(@"%@, ----%@", bbrecord, bbrecord.create_date);
           [self.datalistArray addObject:bbrecord];
        }
        bShouldReload = YES;
        iStartIndex_ += array.count;
        [self.datalistArray sortedArrayUsingFunction:compareRecords context:nil];
        //BBINFO(@"2222 %@", self.datalistArray);
    }
    else //说明没有了
    {
        bShouldReload = NO;
    }
    
    if(bShouldReload || iStartIndex_ == 0)
    {
        self.tableDelegate.arrayDataList = self.datalistArray;
    }
    [self.homeTableView  reloadData];
}



#pragma mark --- BBViewControlerLoadMoreDelegate
-(void) doRefresh
{
    BBLOG();
}

-(void) loadMore
{
    BBLOG();
}

#pragma mark ---nt
- (void)tableviewDidSelect:(NSNotification *)nt
{
    // section 0 是数据，1是最后的日期的标注
    // 0行是背景图
    // 1-n是数据
    BBINFO(@"%@", nt.userInfo);
    NSIndexPath *indexPath = [nt.userInfo objectForKey:@"indexpath"];
    if(indexPath.section == 1)
        return;
    int iRow = indexPath.row;
    if (iRow == 0) {
        UIActionSheet *acctionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Change the Cover", nil), nil];
        acctionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [acctionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    else
    {
        iRow = iRow - 1;
//        KTPhotoScrollViewController *vc = [[KTPhotoScrollViewController alloc] initWithImageArray:self.datalistArray andStartWithPhotoAtIndex:iRow andLocalFile:YES];
        BB_BBRecord *bbrecord = [self.datalistArray objectAtIndex:iRow];
        RichEditViewController *vc = [[RichEditViewController alloc] initWithRecored:bbrecord];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --- actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Change the Cover", nil)])
    {
        HomeSelectViewController *vc = [[HomeSelectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma  mark ----press event 


- (void)rightNavPressed:(id)sender
{
    RichEditViewController  *vc = [[RichEditViewController alloc] initWithNewNote];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)isSupportSwipePop {
    return YES;
}

@end
