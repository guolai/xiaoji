//
//  SettinViewController.m
//  M6s
//
//  Created by zhuhb on 13-4-4.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "SettinViewController.h"
#import "SettingCell.h"
#import "Constant.h"
#import "DataModel.h"
#import "BBSkin.h"
#import "BBUserDefault.h"
#import "SkinViewController.h"
#import "PasswordViewController.h"
#import "FontViewController.h"
#import "NSDate+String.h"
#import <MessageUI/MessageUI.h>

@interface SettinViewController ()<UITableViewDelegate, UITableViewDataSource, OnBtnSwitchPressedDelegate, UIAlertViewDelegate ,PasswordViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    NSArray *listArray_;
    NSArray *sectionArray_;
}
@property (nonatomic, retain) UITableView *tblView;
@end

@implementation SettinViewController
@synthesize tblView;

- (void)didReceiveMemoryWarning
{
    if(OS_VERSION >= 6.0)
    {
        if (self.isViewLoaded && !self.view.window)
        {
            [self.tblView removeFromSuperview];
            self.tblView = nil;
        }
    }
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *array1 = [NSArray arrayWithObjects:NSLocalizedString(@"skin", nil),  NSLocalizedString(@"text", nil),/*  NSLocalizedString(@"Security Password", nil),  NSLocalizedString(@"animation sound", nil), */nil];
    NSArray *array2 = [NSArray arrayWithObjects:NSLocalizedString(@"qq", nil),  NSLocalizedString(@"sina", nil), NSLocalizedString(@"weixin", nil), NSLocalizedString(@"renren", nil), nil];
    NSArray *array3 = [NSArray arrayWithObjects:NSLocalizedString(@"Lock Screen", nil),/* NSLocalizedString(@"auto sync", nil), NSLocalizedString(@"sync via wifi", nil),*/ nil];
    NSArray *array4 = [NSArray arrayWithObjects:/* NSLocalizedString(@"the secrect you don't know", nil),  NSLocalizedString(@"contact to us", nil), */  NSLocalizedString(@"Fead back", nil),  NSLocalizedString(@"give it a good mark", nil), NSLocalizedString(@"More apps", nil), nil];
    listArray_ = [NSArray arrayWithObjects:array1,/* array2,*/ array3, array4, nil];
    sectionArray_ = [NSArray arrayWithObjects:NSLocalizedString(@"invidital", nil),/* NSLocalizedString(@"twitter", nil), */NSLocalizedString(@"private", nil), NSLocalizedString(@"abount bbnote", nil), nil];
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
    
    self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(5.0, fTop, self.width - 10.0f, viewHeight) style:UITableViewStyleGrouped];
    //    self.tblView.separatorStyle = UITableViewCellAccessoryNone;
    if(OS_VERSION  >= 7.0)
    {
        [self.tblView setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.tblView setBackgroundColor:[UIColor clearColor]];
        [self.tblView setBackgroundView:nil];
    }
    [self.view addSubview:self.tblView];
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    self.tblView.tableFooterView = [UIView new];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showBackButton:NSLocalizedString(@"Home", nil) action:nil];
    [self showTitle:NSLocalizedString(@"Setting", nil)];
    [self.tblView reloadData];
    [self.view setBackgroundColor:[BBSkin shareSkin].bgColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark table datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return listArray_.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 30)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
    [lbl  setTextColor:[BBSkin shareSkin].titleColor];
    [lbl setFont:[UIFont boldSystemFontOfSize:14]];
    [lbl  setBackgroundColor:[UIColor clearColor]];
    [lbl setText:[sectionArray_ objectAtIndex:section]];
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
    NSArray *array = [listArray_ objectAtIndex:indexPath.section];
    if((indexPath.section == 0 && indexPath.row == 3) || /*动画声音*/
       indexPath.section == 1/* 微博分享*/
       /*|| (indexPath.section == 2)*/)
    {
        static NSString *strCell = @"setswitchcell";
        SwitchBtnTableCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if(!cell)
        {
            cell = [[SwitchBtnTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
            cell.btnDelegate = self;
        }
        cell.lblType.text = [array objectAtIndex:indexPath.row];
        cell.lblType.textColor = [BBSkin shareSkin].bgTxtColor;
//        if(indexPath.section == 1)
//        {
//            if(indexPath.row == 0)
//            {
//                [cell.btnSwitch setOn:[BBUserDefault getQQstatus] animated:YES];
//            }
//            else if(indexPath.row == 1)
//            {
//                [cell.btnSwitch setOn:[BBUserDefault getSinastatus] animated:YES];
//            }
//            else if(indexPath.row == 2)
//            {
//                [cell.btnSwitch setOn:[BBUserDefault getTcWeibostatus] animated:YES];
//            }
//            else if(indexPath.row == 3)
//            {
//                [cell.btnSwitch setOn:[BBUserDefault getRenrenstatus] animated:YES];
//            }
//    
//        }
        if(indexPath.section == 0)
        {
            [cell.btnSwitch setOn:[BBUserDefault getSoundstatus] animated:YES];
        }
        else if(indexPath.section == 1)
        {
            switch (indexPath.row) {
                case 0:
                {
                    [cell.btnSwitch setOn:[BBUserDefault isOpenedProtect] animated:YES];
                }
                    break;
                case 1:
                {
                    [cell.btnSwitch setOn:[BBUserDefault getAutoSyncstatus] animated:YES];
                }
                    break;
                case 2:
                {
                    [cell.btnSwitch setOn:[BBUserDefault getLockScreenStatus] animated:YES];
                }
                    break;
                default:
                    break;
            }
            
        }
        return cell;
    }
    else
    {
        static NSString *strCell = @"settextcell";
        SetTextTableCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if(!cell)
        {
            cell = [[SetTextTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        }
        cell.lblName.textColor = [BBSkin shareSkin].bgTxtColor;
        cell.lblText.textColor = [BBSkin shareSkin].bgTxtLightColor;
        cell.lblName.text = [array objectAtIndex:indexPath.row];
        cell.lblText.text = nil;
        if(indexPath.section == 0 && indexPath.row == 2)
        {
            if([BBUserDefault getPasswdStatus])
            {
                cell.lblText.text =NSLocalizedString(@"opened", nil);
            }
            else
            {
                cell.lblText.text =NSLocalizedString(@"closed", nil);
            }
        }
        return cell;
    }

    return nil;
}


#pragma mark table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            SkinViewController *vc = [[SkinViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == 1)
        {
            FontViewController *vc = [[FontViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
//    else if(indexPath.section == 2)
//    {
//        if(indexPath.row == 0)
//        {
//
//        }
//        else
//        {
//            [self showProgressHUDWithDetail:NSLocalizedString(@"This feature is temporarily not available", nil) hideafterDelay:2.0];
//        }
//    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            if(![MFMailComposeViewController canSendMail])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Please set your email account", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancle", nil) otherButtonTitles:nil];
                [alertView show];
                return;
            }
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            
            
            [mc setSubject:NSLocalizedString(@"Feed back(微日记)", nil)];
            [mc setMessageBody:@"" isHTML:NO];
            [mc setToRecipients:@[@"554094074@qq.com"]];
            [self presentViewController:mc animated:YES completion:NULL];
        }
        else if(indexPath.row == 1)
        {
            NSString *strMyid = [NSString stringWithFormat:
                                 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", MYAPPID];
            BBINFO(@"myid %@", strMyid);
            if(OS_VERSION >= 7.0)
            {
                strMyid = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/zine/id%@?ls=1&mt=8", MYAPPID];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strMyid]];
        }
        else
        {
            NSString *strMyid = @"https://itunes.apple.com/cn/artist/laiguo/id563990126?l=en";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strMyid]];
        }
    }
}

#pragma mark event


#pragma mark alertviewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"更新"])
    {
        NSString *iTunesLink = [NSString stringWithFormat:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=<</span>%@>&mt=8", MYAPPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}

#pragma mark btnswtichdelegate
- (void)onBtnSwitchPressed:(NSDictionary *)dic
{
    if ([dic objectForKey:@"name"] && [[dic objectForKey:@"name"] isEqualToString:NSLocalizedString(@"Lock Screen", nil)]) {
        
        if([BBUserDefault isOpenedProtect])
        {
            [BBUserDefault setProtectPasswrod:Nil];
            [self.tblView reloadData];
            return;
        }
        PasswordViewController *vc = [[PasswordViewController alloc] init];
        vc.passwordDelegate = self;
        //SocialViewController *vc = [[SocialViewController alloc] init];
        //        LockViewController *vc = [[LockViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark --- password change
- (void)PasswordViewControllerDidCancle:(UIViewController *)viewcontroller
{
    [BBUserDefault setProtectPasswrod:Nil];
    [self.tblView reloadData];
}
- (void)PasswordViewDidSetPassword:(UIViewController *)viewcontorller{
    [self.tblView reloadData];
}

#pragma mark -- mail delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //            Vlog(@"Mail cancelled");
            //            break;
        case MFMailComposeResultSaved:
            //   Vlog(@"Mail saved");
        case MFMailComposeResultFailed:
            //         Vlog(@"Mail sent failure: %@", [error localizedDescription]);
            [self showProgressHUDWithStr:NSLocalizedString(@"Mail send failed", nil) hideafterDelay:2.0];
            break;
        case MFMailComposeResultSent:
            [self showProgressHUDWithStr:NSLocalizedString(@"Mail send success", nil) hideafterDelay:2.0];
            break;
            
            
            break;
        default:
            break;
    }
}



@end
