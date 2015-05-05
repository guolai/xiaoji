//
//  BBAlbumViewController.m
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBAlbumTableViewController.h"
#import "BBAssetPikerState.h"
#import "BBAssetTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface BBAlbumTableViewController ()

@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, retain) NSMutableArray *assetGroupsArray;
@end

@implementation BBAlbumTableViewController
@synthesize assetsLibrary = _assetsLibrary;
@synthesize assetGroupsArray = _assetGroupsArray;
@synthesize assetPickerState;
- (void)dealloc
{
    BBDEALLOC();
}

- (ALAssetsLibrary *)assetsLibrary
{
    if(!_assetsLibrary)
    {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (NSMutableArray *)assetGroupsArray
{
    if(!_assetGroupsArray)
    {
        _assetGroupsArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _assetGroupsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showTitle:NSLocalizedString(@"Loading...", nil)];
    [self showRigthButton:NSLocalizedString(@"Cancle", nil) withImage:nil highlightImge:nil  andEvent:@selector(cancleBtnPressed:)];
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        if(group == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showTitle:NSLocalizedString(@"Albums", nil)];
                for (int i = 0; i < self.assetGroupsArray.count; i++) {
                    
                    ALAssetsGroup *group = [self.assetGroupsArray objectAtIndex:i];
                    if([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos)
                    {
                        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                        [self tableView:self.tableView didSelectRowAtIndexPath:index];
                        break;
                    }
                }
            });
           
            return ;
        }
        //            Vlog(@"=====  %@, ---%@", [group valueForProperty:ALAssetsGroupPropertyType], self.assetGroupsArray);
        if([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos)
        {
            [self.assetGroupsArray insertObject:group atIndex:0];
        }
        else
        {
            [self.assetGroupsArray addObject:group];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }failureBlock:^(NSError *error){
//        Vlog(@"----- error %@", error.description);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == ALAssetsLibraryAccessUserDeniedError) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Inaccessible albums in the 'Settings -> Privacy -> Photos' set to open", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                [alertView show];
                
            }else{
                
                NSLog(@"相册访问失败.");
                
            }
            [self showTitle:error.localizedDescription];
        });
        
    }];
    if(OS_VERSION >= 7.0)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}


#pragma mark event


- (void)cancleBtnPressed:(id)sender
{
    self.assetPickerState.state = BBAssetPikerStatePikingCancelled;
}

#pragma mark rotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskPortrait;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}
#pragma mark tableview datasource delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetGroupsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellIndentifier = @"BBAlumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCellIndentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIndentifier];
    }
    //BBINFO(@"%@", self.assetGroupsArray);
    ALAssetsGroup *group = [self.assetGroupsArray objectAtIndex:indexPath.row];
    //BBINFO(@"%@", group);
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", NSLocalizedString([group valueForProperty:ALAssetsGroupPropertyName], nil),[group numberOfAssets]];
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BBINFO(@"%@", indexPath);
    ALAssetsGroup *group = [self.assetGroupsArray objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    BBAssetTableViewController *vc = [[BBAssetTableViewController alloc] init];
    vc.assetPickerState = self.assetPickerState;
    vc.assetsGroup = group;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57.0f;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
