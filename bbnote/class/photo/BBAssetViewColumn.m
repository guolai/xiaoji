//
//  BBAssetViewColumn.m
//  M6s
//
//  Created by zhuhb on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//
#import "BBAssetPikerState.h"
#import "BBAssetViewColumn.h"

@interface BBAssetViewColumn ()

@end

@implementation BBAssetViewColumn




- (void)dealloc
{
   //BBDEALLOC();
}

- (void)setthumbnailImage:(UIImage *)thumbnail
{
    //BBINFO(@"@@@@@@@@   %f--%f", thumbnail.size.width, thumbnail.size.height);
    _imgeView.image = thumbnail;
}

- (void)setthumbnailColor:(UIColor *)color
{
    _imgeView.image = nil;
    [_imgeView setBackgroundColor:color];
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapAction:)];
        [self addGestureRecognizer:tapGst];
        _imgeView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgeView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgeView];
        _imgeView.clipsToBounds = YES;
        UIImage *img = [UIImage imageNamed:@"skin_check.png"];
        CGSize size = self.bounds.size;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width - img.size.width, size.height - img.size.height, img.size.width, img.size.height)];
        [imgView setImage:img];
        imgView.hidden = YES;
        [self addSubview:imgView];
        _maskView = imgView;
    }
    return self;
}

- (instancetype)init
{
    if(self = [super init])
    {
        NSAssert(false, @"shouduse initWithFrame");
    }
    return self;
}

- (void)setBSelected:(BOOL)bSelected
{
    if(_bSelected != bSelected)
    {
        _bSelected = bSelected;
        if(self.bShouldSeleted && _bSelected)
        {
            _maskView.hidden = NO;
        }
        else
        {
            _maskView.hidden = YES;
        }
    }
}



#pragma mark event

- (void)userDidTapAction:(UITapGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        self.bSelected = YES;
        if ([self.delegate respondsToSelector:@selector(bbassetViewColoumnDidClick:selected:)])
        {
            [self.delegate bbassetViewColoumnDidClick:self selected:YES];
        }
    }
}

@end
