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
#import "BBRecord.h"
#import "BContent.h"
#import "BBContent.h"
#import "BBImage.h"
#import "BBAudio.h"
#import "FileManagerController.h"  
#import "BBMisc.h"
#import "NSNumber+Sort.h"
#import "KTPhotoScrollViewController.h"
#import "SettinViewController.h"
#import "SelectBgViewController.h"
#import "TextViewController.h"
#import "MediaViewController.h"
#import "NSDate+String.h"
#import "BBUserDefault.h"
#import "NSString+UUID.h"
#import "MediaViewController.h"
#import "TextViewController.h"
#import "UIImage+SCaleImage.h"
#import "DataModel.h"
#import "DataManager.h"
#import "HomeSelectViewController.h"

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
        NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
        BRecord *brecord = [[BRecord alloc] init];
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
        BBRecord *bbrecord = [BBRecord initWithBRecord:brecord];
        bbrecord.create_date = [NSDate getNoteBirthDay];
        BContent *bcontent = [[BContent alloc] init];
        bcontent.text_color = noteset.strTextColor;
        bcontent.fontsize = noteset.nFontSize;
        bcontent.font = noteset.strFontName;
        NSString *strFloder = [DataModel getNotePath:bbrecord];
            
        
        
//        bcontent.text = @"心怀温暖，直面残酷 \n是的，青春终将散场，现实远比电影更加残酷无情，有着更多的失望甚至绝望，有着更加浓重的黑色，曾经的爱情、梦想、信仰可能会被击得粉碎。但不妨为心保留一块温柔的地方，心怀温暖，直面残酷。";
        bcontent.text = @"用美妙的文字记录下此刻感想，用生动的图片定格青春的每一个精彩的瞬间，用声音缅怀那些曾经的青涩，用视频见证我们共同的欢笑。我准备好了，你呢";
        BBText *bbcontent = [BBText BBContentWithBContent:bcontent];
        bbcontent.create_date = [NSDate getNoteBirthDay];
        bbcontent.modify_date = [NSDate getNoteBirthDay];
        [bbcontent save];
        bbrecord.contentInRecord = bbcontent;
        for (int i = 0; i < 4; i++) {
            @autoreleasepool {
                NSString *strPath = [NSString stringWithFormat:@"record0%d.jpg", i];
                BBINFO(@"%@", strPath);
                UIImage *img = [UIImage imageNamed:strPath];
//                UIImage *smlImg = [img imageAutoScale];
                BBINFO(@"%@", strPath);
                BBImage *bbimg = [BBImage create];
                bbimg.create_date = [NSDate getNoteBirthDay];
                bbimg.width = [NSNumber numberWithFloat:img.size.width];
                bbimg.height = [NSNumber numberWithFloat:img.size.height];
                bbimg.size = [NSNumber numberWithFloat:30000];
                bbimg.key = [NSString generateKey];
                bbimg.data_path = [NSString stringWithFormat:@"%@.jpg", bbimg.key];
//                bbimg.data_small_path = [NSString stringWithFormat:@"%@sml.jpg", bbimg.key];
                bbimg.iscontent = [NSNumber numberWithBool:NO];
                bbimg.record = bbrecord;
                [bbimg save];
                NSString *strOldPath = [[FileManagerController resourcesPath] stringByAppendingPathComponent:strPath];
                NSString *strNewPath = [strFloder stringByAppendingPathComponent:bbimg.data_path];
                [FileManagerController copyItem:strOldPath toItem:strNewPath];
//                NSData *data = UIImageJPEGRepresentation(smlImg, 1.0);
//                [data writeToFile:[strFloder stringByAppendingPathComponent:bbimg.data_small_path] atomically:YES];
            }
            
        }
        //audio
        {
            NSString *strPath = [[FileManagerController resourcesPath] stringByAppendingPathComponent:@"Relax.caf"];
            NSData *data = [NSData dataWithContentsOfFile:strPath];
            BBAudio *audio = [BBAudio create];
            audio.record = bbrecord;
            audio.create_date = [NSDate getNoteBirthDay];
            audio.key = [NSString generateKey];
            audio.data_path = [NSString stringWithFormat:@"%@.caf", audio.key];
            audio.size = [NSNumber numberWithFloat:data.length];
            audio.times = [NSNumber numberWithFloat:41.0f];
            [audio save];
            NSString *strOldPath = strPath;
            NSString *strNewPath = [strFloder stringByAppendingPathComponent:audio.data_path];
            [FileManagerController copyItem:strOldPath toItem:strNewPath];
        }
 
        { // save text to image
            UIImage *img = [BBMisc createImageForBigWeibo:bbrecord];
            NSData *data = UIImageJPEGRepresentation(img, 1.0);
            BImage *bimg = [BBMisc saveAssetImageToSand:data smlImag:nil path:strFloder isContent:YES];
            BBImage *bbimage = [BBImage BBImageWithBImage:bimg];
            
            bbimage.record = bbrecord;
            [bbimage save];
        }
        [bbrecord save];
        [bbrecord saveToSandBoxPath:[DataModel getNotePath:bbrecord]];
    }
}


- (void)rebuildMenu
{
    bFrist_ = YES;
    iStartIndex_ = 0;
    iLimit_  = 100;
    [self.datalistArray removeAllObjects];
    [self requestData];
}


- (void)requestData
{
    BOOL bShouldReload = NO;
    
    NSArray *array = [BBRecord where:nil startFrom:iStartIndex_ limit:iLimit_ sortby:@"create_date^0"];
    //BBINFO(@"1111 %@", self.datalistArray);
    if(array.count > 0)
    {
        for (id record  in array) {
            BBRecord *bbrecord = (BBRecord *)record;
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
        KTPhotoScrollViewController *vc = [[KTPhotoScrollViewController alloc] initWithImageArray:self.datalistArray andStartWithPhotoAtIndex:iRow andLocalFile:YES];
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
    MediaViewController  *vc = [[MediaViewController alloc] initWithNewNote];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)isSupportSwipePop {
    return YES;
}

@end
