//
//  BBAssetsCell.h
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBAssetsTableViewCellDelegate;

@interface BBAssetsCell : UITableViewCell
@property (nonatomic, strong)NSMutableArray *arrayViews;
@property (nonatomic, weak) id<BBAssetsTableViewCellDelegate> delegate;
- (id)initWithReuseIdentifier:(NSString *)strIndefi;
- (void)setCellAssetViewsArray:(NSArray *)cellAstViewsArray;

@end


@protocol BBAssetsTableViewCellDelegate <NSObject>

- (void)assetsTableViewCell:(BBAssetsCell *)cell  didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column;

@end