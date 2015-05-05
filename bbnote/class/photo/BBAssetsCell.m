//
//  BBAssetsCell.m
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//
#import "BBAssetPikerState.h"
#import "BBAssetsCell.h"
#import "BBAssetWrapper.h"
#import "BBAssetViewColumn.h"   
#import <AssetsLibrary/AssetsLibrary.h>

@implementation BBAssetsCell
@synthesize delegate;
@synthesize arrayViews;
                                                           
- (void)dealloc
{
   // BBDEALLOC();
    [self stopObserving];
    self.arrayViews = nil;
    self.delegate = nil;
}

- (id)initWithReuseIdentifier:(NSString *)strIndefi
{
    if((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndefi]))
    {
//        BBDEALLOC();
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        [self initColums];
    }
    return self;
}



- (void)initColums
{
    self.arrayViews = [NSMutableArray arrayWithCapacity:PHOTO_COLUMN_COUNT];
    float width = (SCR_WIDTH-(PHOTO_COLUMN_COUNT+1)*PHOTO_VIEW_PADDING)/PHOTO_COLUMN_COUNT;
    
    CGRect rct;
    rct.origin.x = PHOTO_VIEW_PADDING;
    rct.origin.y = 3;
    rct.size = CGSizeMake(width, width);

    
    for(int i = 0; i < PHOTO_COLUMN_COUNT; i++)
    {
        BBAssetViewColumn *assetViewColumn = [[BBAssetViewColumn alloc] initWithFrame:rct];
        assetViewColumn.frame = rct;
        assetViewColumn.column = i;
        [assetViewColumn addObserver:self forKeyPath:kPHOTO_SELECTED options:NSKeyValueObservingOptionNew context:NULL];
        [self addSubview:assetViewColumn];
        [self.arrayViews addObject:assetViewColumn];
        rct.origin.x = rct.origin.x + rct.size.width + PHOTO_VIEW_PADDING;
    }
}

- (void)stopObserving
{
    for (BBAssetViewColumn *assetViewColumn in self.arrayViews) {
        [assetViewColumn removeObserver:self forKeyPath:kPHOTO_SELECTED];
        //[assetViewColumn removeFromSuperview];
    }
}

- (void)setCellAssetViewsArray:(NSArray *)cellAstViewsArray
{
    NSAssert(cellAstViewsArray.count <= self.arrayViews.count, @"error");
    int iIndex = 0;
    for(BBAssetWrapper *assetWrapper in cellAstViewsArray)
    {
        BBAssetViewColumn *assetViewColumn = (BBAssetViewColumn *)[self.arrayViews objectAtIndex:iIndex];
        [assetViewColumn setthumbnailImage:[UIImage imageWithCGImage:assetWrapper.asset.thumbnail]];
        assetViewColumn.hidden = NO;
        iIndex ++;
    }
    for (int i =iIndex; i < self.arrayViews.count; i++) {
        BBAssetViewColumn *assetViewColumn = (BBAssetViewColumn *)[self.arrayViews objectAtIndex:i];
        assetViewColumn.hidden = YES;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([object isMemberOfClass:[BBAssetViewColumn class]])
    {
        BBAssetViewColumn *column = (BBAssetViewColumn *)object;
        if([self.delegate respondsToSelector:@selector(assetsTableViewCell:didSelectAsset:atColumn:)])
        {
            [self.delegate assetsTableViewCell:self didSelectAsset:YES atColumn:column.column];
        }
    }
}

@end
