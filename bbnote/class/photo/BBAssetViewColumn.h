//
//  BBAssetViewColumn.h
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBAssetViewColumn : UIView
{
    UIImageView *_imgeView;
}


@property (nonatomic) NSUInteger column;
@property (nonatomic, getter = isSelected) BOOL selected;

- (void)setthumbnailImage:(UIImage *)thumbnail;

@end
