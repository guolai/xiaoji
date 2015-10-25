//
//  BBAssetViewColumn.h
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBAssetViewColumn;

@protocol BBAssetViewColumnDelegate <NSObject>
- (void)bbassetViewColoumnDidClick:(BBAssetViewColumn *)viewColumn selected:(BOOL)bValue;
@end


@interface BBAssetViewColumn : UIView
{
    UIImageView *_imgeView;
    UIImageView *_maskView;
}

@property (nonatomic, assign) BOOL bShouldSeleted;//是否显示选中态
@property (nonatomic) NSUInteger column;
@property (nonatomic, assign) BOOL bSelected;
@property (nonatomic, weak) id<BBAssetViewColumnDelegate> delegate;


- (void)setthumbnailImage:(UIImage *)thumbnail;
- (void)setthumbnailColor:(UIColor *)color;

@end
