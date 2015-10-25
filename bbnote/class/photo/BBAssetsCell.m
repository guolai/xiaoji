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
#import "BBAutoSize.h"
#import "NSString+UIColor.h"
#import "DataManager.h"

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
    //    float width = (SCREEN_WIDTH - (PHOTO_COLUMN_COUNT + 1) * PHOTO_VIEW_PADDING ) / PHOTO_COLUMN_COUNT;
    CGFloat fleft = 10;
    CGFloat fMargin = [BBAutoSize resizeWidth:7];
    float width = (SCR_WIDTH - (PHOTO_COLUMN_COUNT - 1) * fMargin - fleft * 2 ) / PHOTO_COLUMN_COUNT;
    
    CGRect rct;
    rct.origin.x = fleft;
    rct.origin.y = fMargin;
    rct.size = CGSizeMake(width, width);
    
    
    for(int i = 0; i < PHOTO_COLUMN_COUNT; i++)
    {
        BBAssetViewColumn *assetViewColumn = [[BBAssetViewColumn alloc] initWithFrame:rct];
        assetViewColumn.frame = rct;
        assetViewColumn.column = i;
        assetViewColumn.delegate = self;
        [self addSubview:assetViewColumn];
        [self.arrayViews addObject:assetViewColumn];
        rct.origin.x = rct.origin.x + rct.size.width + fMargin;
    }
}
- (void)stopObserving
{
    for (BBAssetViewColumn *assetViewColumn in self.arrayViews) {
         assetViewColumn.delegate = nil;
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
        if (assetWrapper.asset)
        {
            [assetViewColumn setthumbnailImage:[UIImage imageWithCGImage:assetWrapper.asset.thumbnail]];
            assetViewColumn.bShouldSeleted = NO;
        }
        else if (assetWrapper.paper)
        {
            PaperType type = assetWrapper.paper.paperType;
            if(type == Paper_Color)
            {
                 UIColor *color = [assetWrapper.paper.strName getColorFromRGBA];
                [assetViewColumn setthumbnailColor:color];
                 assetViewColumn.bShouldSeleted = YES;
            }
            else if (type == Paper_Picture)
            {
                [assetViewColumn setthumbnailImage:[UIImage imageNamed:assetWrapper.paper.strName]];
                assetViewColumn.bShouldSeleted = YES;
            }
            else
            {
                NSParameterAssert(false);
            }
            PaperItem *paper = assetWrapper.paper;
            NoteSetting *notesetting = [[DataManager ShareInstance] noteSetting];
            if (!notesetting.isUseBgImg && [paper.strName isEqualToString:notesetting.strBgColor] && paper.paperType == Paper_Color)
            {
                assetViewColumn.bSelected = YES;
            }
            else if (notesetting.isUseBgImg && [paper.strName isEqualToString:notesetting.strBgImg] && paper.paperType == Paper_Picture)
            {
                assetViewColumn.bSelected = YES;
            }
            else
            {
                assetViewColumn.bSelected = NO;
            }
        }
        else
        {
            NSParameterAssert(false);
        }
        
        assetViewColumn.hidden = NO;
        iIndex ++;
    }
    for (int i =iIndex; i < self.arrayViews.count; i++) {
        BBAssetViewColumn *assetViewColumn = (BBAssetViewColumn *)[self.arrayViews objectAtIndex:i];
        assetViewColumn.hidden = YES;
    }
}

- (void)bbassetViewColoumnDidClick:(BBAssetViewColumn *)viewColumn selected:(BOOL)bValue
{
    if([viewColumn isKindOfClass:[BBAssetViewColumn class]])
    {
        if([self.delegate respondsToSelector:@selector(assetsTableViewCell:didSelectAsset:atColumn:)])
        {
            [self.delegate assetsTableViewCell:self didSelectAsset:bValue atColumn:viewColumn.column];
        }
    }
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if([object isMemberOfClass:[BBAssetViewColumn class]])
//    {
//        BBAssetViewColumn *column = (BBAssetViewColumn *)object;
//        if([self.delegate respondsToSelector:@selector(assetsTableViewCell:didSelectAsset:atColumn:)])
//        {
//            [self.delegate assetsTableViewCell:self didSelectAsset:YES atColumn:column.column];
//        }
//    }
//}

@end
