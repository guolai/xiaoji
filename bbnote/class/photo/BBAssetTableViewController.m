//
//  BBAssetTableViewController.m
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBAssetTableViewController.h"
#import "BBAssetPikerState.h"
#import "BBAssetsCell.h"
#import "BBAssetWrapper.h"  
#import <AssetsLibrary/AssetsLibrary.h>
#import "DataModel.h"
#import "BBNavigationViewController.h"
#import "BBAssetPikerState.h"

@interface BBAssetTableViewController ()<BBAssetsTableViewCellDelegate>
@property (nonatomic, retain) NSMutableArray *fetchedAssetsArray;
@property (nonatomic, readonly) NSInteger assetsPerRow;
@property (nonatomic, retain) UITableView *tblView;
@end

@implementation BBAssetTableViewController
@synthesize fetchedAssetsArray = _fetchedAssetsArray;
@synthesize assetsPerRow = _assetsPerRow;
@synthesize assetsGroup;
@synthesize tblView;
@synthesize assetPickerState;
@synthesize scrView;


- (void)dealloc
{
    BBDEALLOC();
}

- (void)viewDidLoad
{
    [self showBackButton:nil action:nil];
    [self showTitle:[NSString stringWithFormat:@"%@", NSLocalizedString([self.assetsGroup  valueForProperty:ALAssetsGroupPropertyName], nil)]];
    [self showRigthButton:NSLocalizedString(@"Done", nil) withImage:nil highlightImge:nil  andEvent:@selector(doneBtnPressed:)];
    [self fetchAssets];
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - self.navBarHeight)];
    self.view  = view;
    [self.view setBackgroundColor:[UIColor grayColor]];
    float viewHeight = self.height;
    float fTop = 0;
    
    if(OS_VERSION < 7.0)
    {
        viewHeight -= self.navBarHeight;
        viewHeight -= SCR_STATUS_BAR;
    }
    else
    {
        
    }
    self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, fTop, self.width, viewHeight - PHOTO_SELECT_BTM_HEIGHT)];
//    [self.tblView setContentSize:CGSizeMake(SCR_WIDTH, SCR_HEIGHT)];
//    [self.tblView setContentInset:UIEdgeInsetsMake(SCR_TOPBAR + 2, 0, 2, 0)];
    [self.tblView setContentInset:UIEdgeInsetsMake(2, 0, 2, 0)];
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    //self.tblView.contentInset = PHOTO_TABLEVIEW_INSETS;
    self.tblView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tblView];
    
    self.scrView = [[SelectedImageScrollView alloc] initWithFrame:CGRectMake(0, viewHeight  - PHOTO_SELECT_BTM_HEIGHT, self.width, PHOTO_SELECT_BTM_HEIGHT) maxCount:8];
    self.scrView.saveDelegate = self;
    [self.view addSubview:self.scrView];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((self.fetchedAssetsArray.count + self.assetsPerRow - 1) / self.assetsPerRow);
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)indexPath
{
    NSRange assetRange;
    assetRange.location = indexPath.row * self.assetsPerRow;
    assetRange.length = self.assetsPerRow;
    
    // Prevent the range from exceeding the array length.
    if (assetRange.length > self.fetchedAssetsArray.count - assetRange.location) {
        assetRange.length = self.fetchedAssetsArray.count - assetRange.location;
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:assetRange];
    
    // Return the range of assets from fetchedAssets.
    return [self.fetchedAssetsArray objectsAtIndexes:indexSet];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AssetCellIdentifier = @"BBAssetCell";
    BBAssetsCell *cell = [self.tblView dequeueReusableCellWithIdentifier:AssetCellIdentifier];
    
    if (cell == nil)
    {
        
        cell = [[BBAssetsCell alloc] initWithReuseIdentifier:AssetCellIdentifier];
        cell.delegate = self;
    }
    [cell setCellAssetViewsArray:[self assetsForIndexPath:indexPath]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return (SCR_WIDTH-(PHOTO_COLUMN_COUNT+1)*PHOTO_VIEW_PADDING)/PHOTO_COLUMN_COUNT + PHOTO_VIEW_PADDING;
}

#pragma  mark event 
-(void)doneBtnPressed:(id)sender
{
    [self.scrView saveAllImage];
    self.assetPickerState.state = BBAssetPikerStatePikingDone;
}

#pragma mark fetching 
- (void)fetchAssets
{
    if(!self.assetsGroup || !self.fetchedAssetsArray)
        return;
    dispatch_queue_t enumQ = dispatch_queue_create("AssetEnumeration", NULL);
    dispatch_async(enumQ, ^{
        [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop ){
            if(!result || index == NSNotFound)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tblView reloadData];
                });
                return ;
            }
            //BBINFO(@"=== %@", result);
//            UIImage *img = [[[UIImage alloc] initWithCGImage:result.defaultRepresentation.fullResolutionImage] autorelease];
//            BBINFO(@"%f----%f=== %@",img.size.width, img.size.height, result);
            BBAssetWrapper *assetWrapper = [[BBAssetWrapper alloc] initWithAsset:result];
            [self.fetchedAssetsArray addObject:assetWrapper];
          
        }];
    });

}

#pragma  mark getter


- (NSMutableArray *)fetchedAssetsArray
{
    if(!_fetchedAssetsArray)
    {
        _fetchedAssetsArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _fetchedAssetsArray;
}

- (NSInteger)assetsPerRow
{
    return PHOTO_COLUMN_COUNT;
}


#pragma mark rotation

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    [self.tblView reloadData];
//}

#pragma mark - WSAssetsTableViewCellDelegate Methods

- (void)assetsTableViewCell:(BBAssetsCell *)cell didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column
{
    BBINFO(@"@@@@@@@ %d", selected);

    NSIndexPath *indexPath = [self.tblView indexPathForCell:cell];

    // Calculate the index of the corresponding asset.
    NSUInteger assetIndex = indexPath.row * self.assetsPerRow + column;
    BBAssetWrapper *assetWrapper = [self.fetchedAssetsArray objectAtIndex:assetIndex];

    BBINFO(@"%@", assetWrapper.asset.debugDescription);
    NSString *strName = assetWrapper.asset.defaultRepresentation.filename;
//    UIImage *img = [UIImage imageWithCGImage:assetWrapper.asset.thumbnail];
//    UIImage *bigimg =  [UIImage imageWithCGImage:assetWrapper.asset.defaultRepresentation.fullResolutionImage];
//    BBINFO(@"%@\n%@", img.debugDescription, bigimg.debugDescription);
    NSString *strResult = [self.scrView checkIsSaved:strName];
    if (![strResult isEqualToString:NSLocalizedString(@"saving...", nil)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showProgressHUDWithStr:strResult hideafterDelay:0.3];
        });
        return;

    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showProgressHUDWithStr:strResult];
    });
    dispatch_queue_t queue = dispatch_queue_create("saveimage", NULL);
    dispatch_async(queue, ^{
        @autoreleasepool {
            NSData *bigData = [DataModel dataWithCGImageRefImage:assetWrapper.asset.defaultRepresentation.fullResolutionImage exifInfo:assetWrapper.asset.defaultRepresentation.metadata];
                UIImage *img = [UIImage imageWithCGImage:assetWrapper.asset.thumbnail];
                UIImage *scrImg =  [UIImage imageWithCGImage:assetWrapper.asset.defaultRepresentation.fullScreenImage];
            [self.scrView addImage:scrImg thumbnail:img bigImageData:bigData andName:strName toPath:self.assetPickerState.strValue];
        }
    });
    
    
}


#pragma mark saveimagedelete
- (void)saveImageCompleted:(NSString *)str
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissProgressHUD];
    });
}

- (void)saveImageBegin:(NSString *)str
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showProgressHUDWithStr:str];
    });
}
@end
