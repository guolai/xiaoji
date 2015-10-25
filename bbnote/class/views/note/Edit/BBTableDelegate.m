//
//  BBTableDelegate.m
//  bbnote
//
//  Created by bob on 10/18/15.
//  Copyright © 2015 bob. All rights reserved.
//

#import "BBTableDelegate.h"
#import "BBAutoSize.h"
#import "BBAssetWrapper.h"
#import "BBAssetsCell.h"
#import "DataManager.h"
#import "NoteSetting.h"

@implementation BBTableDelegate
- (void)dealloc
{
    [self removeAllConnection];
}

- (void)removeAllConnection
{
    self.arrayData = [NSArray array];
    self.delegate = nil;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.arrayData = [NSArray array];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((self.arrayData.count + self.assetsPerRow - 1) / self.assetsPerRow);
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)indexPath
{
    NSRange assetRange;
    assetRange.location = indexPath.row * self.assetsPerRow;
    assetRange.length = self.assetsPerRow;
    
    if (assetRange.length > self.arrayData.count - assetRange.location) {
        assetRange.length = self.arrayData.count - assetRange.location;
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:assetRange];
    
    return [self.arrayData objectsAtIndexes:indexSet];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AssetCellIdentifier = @"BBAssetCell";
    BBAssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:AssetCellIdentifier];
    
    if (cell == nil)
    {
        
        cell = [[BBAssetsCell alloc] initWithReuseIdentifier:AssetCellIdentifier];
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    [cell setCellAssetViewsArray:[self assetsForIndexPath:indexPath]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BBAutoSize resizeWidth:78.0];
}

- (NSInteger)assetsPerRow
{
    return 4;
}


#pragma mark - WSAssetsTableViewCellDelegate Methods

- (void)assetsTableViewCell:(BBAssetsCell *)cell didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column
{
    NSIndexPath *indexPath = cell.indexPath;
    NSUInteger assetIndex = indexPath.row * self.assetsPerRow + column;
    if (assetIndex >= self.arrayData.count)
    {
        NSParameterAssert(false);
        return;
    }
    BBAssetWrapper *assetWrapper = [self.arrayData objectAtIndex:assetIndex];
 
    if(assetWrapper.paper)
    {
        PaperItem *paper = assetWrapper.paper;
        NoteSetting *notesetting = [[DataManager ShareInstance] noteSetting];
        if(paper.paperType == Paper_Color)
        {
            notesetting.isUseBgImg = NO;
            notesetting.strBgColor = paper.strName;
        }
        else if(paper.paperType == Paper_Picture)
        {
            notesetting.isUseBgImg = YES;
            notesetting.strBgImg = paper.strName;
        }
        else
        {
            NSParameterAssert(false);
        }
        
//        PhotoSelectedInfo *photoSelectedInfo = [CiPaiManager shareInstance].photoSelectedInfo;
//        photoSelectedInfo.strTitle = self.strTitle;
//        photoSelectedInfo.nIndex = assetIndex;
        if([self.delegate respondsToSelector:@selector(bbPhotoTableViewDidClick:)])
        {
            [self.delegate bbPhotoTableViewDidClick:assetWrapper.paper];
        }
    }
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if ([self.delegate respondsToSelector:@selector(qmScrollViewDidScroll:)])
//    {
//        [self.delegate qmScrollViewDidScroll:scrollView];
//    }
//}

@end
