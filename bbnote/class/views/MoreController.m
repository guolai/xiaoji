//
//  MoreController.m
//  jyy
//
//  Created by bob on 3/22/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "MoreController.h"
#import "GuideViewController.h"
#import "VersionViewController.h"



@interface MoreController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *tblView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *arraySection;
@end

@implementation MoreController
@synthesize tblView;
@synthesize array;


- (void)loadView
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ygkz_bg"]]];
    
    float viewHeight = self.height;
    
    float fWidth = 120;
    float fMargin = 50;
    float fTop = 0;
    float fWSpace = (self.width - fWidth * 2) / 3;
    float fHeight = 40;
    if(OS_VERSION < 7.0)
    {
        viewHeight -= self.navBarHeight;
        viewHeight -= 20;
    }
    else
    {
        fTop = self.navBarHeight;
    }
    self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, viewHeight) style:UITableViewStyleGrouped];
    self.tblView.dataSource = self;
    self.tblView.delegate = self;
    [self.view addSubview:self.tblView];
    
    if(OS_VERSION  >= 7.0)
    {
        [self.tblView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ygkz_bg"]]];
    }
    else
    {
        [self.tblView setBackgroundColor:[UIColor clearColor]];
        [self.tblView setBackgroundView:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton:nil  action:nil];
    self.array = @[@[@"给点建议吧", @" 分享朋友一起使用"], @[@"版本更新", @"关于"]];
    self.arraySection = @[@"分享", @"软件"];
}


#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = [self.arraySection objectAtIndex:section];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont systemFontOfSize:12]];
    label.textColor = [UIColor lightGrayColor];
//    label.shadowColor = [UIColor blackColor];
//    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.frame = CGRectMake( 20, 10, 60, 30);
   	UIView* view = [[UIView alloc] init];
	[view addSubview:label];
	return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.array objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIndefi = @"textcell";
//    NSArray *array = [self.array objectAtIndex:indexPath.section];
//    TextTableCell  *cell = [tableView dequeueReusableCellWithIdentifier:strIndefi];
//    if(!cell)
//    {
//        cell = [[TextTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndefi];
//    }
//    cell.lblName.text = [array objectAtIndex:indexPath.row];
//    if(indexPath.section == 1 && indexPath.row == 1)
//    {
//        cell.lblText.text = @"1.0";
//    }
//    else
//    {
//        cell.lblText.text = @"";
//    }
//    return cell;
    return Nil;
}


#pragma mark -event 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 )
    {
        
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        GuideViewController *vc = [[GuideViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        VersionViewController *vc = [[VersionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
