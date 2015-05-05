//
//  FontViewController.m
//  bbnote
//
//  Created by bob on 7/3/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import "FontViewController.h"
#import "BBSkin.h"
#import "BBTitleView.h"
#import "FontColorCell.h"
#import "SettingCell.h"
#import "BBUserDefault.h"
#import "BgImgeViewController.h"
#import "DataManager.h"

@interface FontViewController ()<UITableViewDataSource, UITableViewDelegate, OnBtnSwitchPressedDelegate>
{
    FontTitleView *fontTitleView_;

    NSArray *arraySections_;
    NSArray *listArray_;
    UITableView *tblView_;
    NSArray *fontsizeArray_;
    NSArray *fontnameArray_;
}
@property (nonatomic, retain)UITableView *tblView;
@end

@implementation FontViewController
@synthesize tblView = tblView_;




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton:NSLocalizedString(@"Setting", nil) action:nil];
    [self showTitle:NSLocalizedString(@"skin", nil)];
    
    arraySections_ = [NSArray arrayWithObjects:@"文字大小",@"文字样式",@"文字颜色",@"使用背景颜色",@"使用背景图片", nil];
    
    listArray_ = @[@[@"小", @"中", @"大"],
                  @[@"默认", @"样式1", @"样式2", @"样式3", @"样式4"],
                  @[@""],
                  @[@""],
                  @[@""]];
    fontsizeArray_ = @[[NSNumber numberWithInt:10],[NSNumber numberWithInt:14], [NSNumber numberWithInt:18]];
    fontnameArray_ = @[@"system",@"FZHuangCao-S09S",@"FZXingKai-S04S",@"snFontP1",@"snFontP2"];
    [self.tblView reloadData];
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
        viewHeight -= self.navBarHeight;
        fTop += self.navBarHeight;
    }
    fontTitleView_ = [[FontTitleView alloc]  initWithFrame:CGRectMake(0, fTop, SCR_WIDTH, 90)];
    [self.view addSubview:fontTitleView_];
    fTop += 90;
    self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, fTop, SCR_WIDTH, self.height - fTop) style:UITableViewStyleGrouped];
    self.tblView.dataSource = self;
    self.tblView.delegate = self;
    [self.tblView setBackgroundColor:[UIColor clearColor]];
    [self.tblView setBackgroundView:nil];
    [self.view addSubview:self.tblView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [fontTitleView_ reloadFontViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[DataManager ShareInstance] saveNoteSetting];
}

#pragma mark table datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arraySections_.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 ||indexPath.section == 3) {
        return 220.0 * fScr_Scale;
    }
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 30)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
    [lbl  setTextColor:[BBSkin shareSkin].titleColor];
    [lbl setFont:[UIFont boldSystemFontOfSize:14]];
    [lbl  setBackgroundColor:[UIColor clearColor]];
    [lbl setText:[arraySections_ objectAtIndex:section]];
    [view addSubview:lbl];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [listArray_ objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
    if(indexPath.section == 0 )
    {
        NSArray *array = [listArray_ objectAtIndex:indexPath.section];
        static NSString *strCell = @"SelectCell";
        SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if(!cell)
        {
            cell = [[SelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
            cell.lblText.textColor = [BBSkin shareSkin].bgTxtColor;
        }
        cell.lblText.text = [array objectAtIndex:indexPath.row];
        cell.checkImg.hidden = YES;
        NSNumber *number = noteset.nFontSize;
        if([number isEqualToNumber:[fontsizeArray_ objectAtIndex:indexPath.row]])
        {
            cell.checkImg.hidden = NO;
        }
        [cell.lblText setFont:[UIFont systemFontOfSize:[[fontsizeArray_ objectAtIndex:indexPath.row] intValue]]];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        NSArray *array = [listArray_ objectAtIndex:indexPath.section];
        static NSString *strCell = @"SelectCell";
        SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if(!cell)
        {
            cell = [[SelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
            cell.lblText.textColor = [BBSkin shareSkin].bgTxtColor;
        }
        cell.lblText.text = [array objectAtIndex:indexPath.row];
        cell.checkImg.hidden = YES;
        NSString *strName = noteset.strFontName;
        if(indexPath.row == 0)
        {
            if( !strName || [strName isEqualToString:@""] || [strName isEqualToString:@"system"])
            {
                cell.checkImg.hidden = NO;
                [cell.lblText setFont:[UIFont systemFontOfSize:14]];
            }
        }
        else
        {
            if([strName isEqualToString:[fontnameArray_ objectAtIndex:indexPath.row]])
            {
                cell.checkImg.hidden = NO;
            }
            [cell.lblText setFont:[UIFont fontWithName:[fontnameArray_ objectAtIndex:indexPath.row] size:14]];
        }
        return cell;
    }
    
    else if(indexPath.section == 2)
    {
        static NSString *strCell = @"FontColorCell";
        FontColorCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if(!cell)
        {
            cell = [[FontColorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        }
        return cell;
    }
    else if(indexPath.section == 3)
    {
        static NSString *strCell = @"FontBGColorCell";
        FontBGColorCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if(!cell)
        {
            cell = [[FontBGColorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        }
        return cell;
    }
    else
    {
        static NSString *strCell = @"setswitchcell";
        SwitchBtnTableCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if(!cell)
        {
            cell = [[SwitchBtnTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
            cell.btnDelegate = self;
            cell.lblType.textColor = [BBSkin shareSkin].bgTxtColor;
        }
        cell.lblType.text = @"请选择背景图片";
        [cell.btnSwitch setOn:noteset.isUseBgImg animated:YES];
     
        return cell;

    }

    return nil;
}


#pragma mark table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
    if(indexPath.section == 0 )
    {
        noteset.nFontSize = [fontsizeArray_ objectAtIndex:indexPath.row];
        [fontTitleView_ reloadFontViews];
        [self.tblView reloadData];
    }
    else if(indexPath.section == 1)
    {
        noteset.strFontName = [fontnameArray_ objectAtIndex:indexPath.row];
        [fontTitleView_ reloadFontViews];
        [self.tblView reloadData];
    }
    else if( indexPath.section == 4)
    {
        BgImgeViewController *vc = [[BgImgeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
      
    }
    
}

#pragma mark btnswtichdelegate
- (void)onBtnSwitchPressed:(NSDictionary *)dic
{
    NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
    if(noteset.isUseBgImg)
    {
        noteset.isUseBgImg = NO;
    }
    else
    {
        noteset.isUseBgImg = YES;
    }
    [fontTitleView_ reloadFontViews];
    [self.tblView reloadData];
}

@end
