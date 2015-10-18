//
//  TestViewController.m
//  bbnote
//
//  Created by bob on 10/18/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import "TestViewController.h"
#import "FontImge.h"
#import "TextCell.h"
#import "BBSkin.h"


@interface TestViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tblView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    self.tblView.dataSource = self;
    self.tblView.delegate = self;
    [self.view addSubview:self.tblView];
    self.arrayData = [NSMutableArray array];
    for (int i = 0; i < FAIconUserMd; i++) {
        [self.arrayData addObject:@(i)];
    }
    [self.tblView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FAIcon iconType = [[self.arrayData objectAtIndex:indexPath.row] integerValue];
//    if(indexPath.row < self.arrayData.count - 1)
    {
        static NSString *strCell = @"icontextCell";
        TextTableCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
        if(!cell)
        {
            cell = [[TextTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        }
        cell.fontImg.bgViewColor = [UIColor clearColor];
        cell.fontImg.iconImgColor = [BBSkin shareSkin].titleBgColor;
        cell.fontImg.iconName = iconType;
        cell.lblName.text = [NSString stringWithFormat:@"%@", [self.arrayData objectAtIndex:indexPath.row]];
        cell.lblText.text = cell.lblName.text;
        cell.myaccessView.hidden = NO;
        
        return cell;
    }
   
    return Nil;
}


#pragma mark table delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    @[NSLocalizedString(@"Timeline", nil), NSLocalizedString(@"Photos", Nil), NSLocalizedString(@"Tags", Nil), NSLocalizedString(@"Calendar", Nil), NSLocalizedString(@"Starred", Nil), NSLocalizedString(@"Setting", Nil), NSLocalizedString(@"iClound", Nil)];
    NSLog(@"%d", indexPath.row);
    FAIcon iconType = [[self.arrayData objectAtIndex:indexPath.row] integerValue];
    NSLog(@"%d", iconType);
  
    
}



@end
