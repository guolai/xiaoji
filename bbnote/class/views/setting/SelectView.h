//
//  SelectView.h
//  bbnote
//
//  Created by zhuhb on 13-6-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectImageDelegate <NSObject>

@optional
- (void)didSelectAColor:(int )ivalue;

- (void)didChangeSkinType:(int )ivalue;

@end

@interface SelectBtnView : UIView
@property (nonatomic, retain)UIImageView *selectView;
@property (nonatomic, assign)id<SelectImageDelegate> selectDelegate;
- (id)initWithFrame:(CGRect)frame withStrColor:(NSString *)strColor;
- (id)initWithFrame:(CGRect)frame withColor:(UIColor *)color;
- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image;
- (id)initWithFrame:(CGRect)frame withBgImage:(UIImage *)image;
@end

@interface SelectView : UIView<SelectImageDelegate>
@property (nonatomic, retain)NSMutableArray *arraySelctView;
@property (nonatomic, retain)NSArray *arrayColors;
@property (nonatomic, assign)id<SelectImageDelegate> selectDelegate;
- (id)initWithFrame:(CGRect)frame withColors:(NSArray *)array cloumn:(int)icloumn;
- (id)initWithFrame:(CGRect)frame withSkinImages:(NSArray *)array cloumn:(int)icloumn;
- (id)initWithFrame:(CGRect)frame withBgImages:(NSArray *)array cloumn:(int)icloumn;

@end
