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
@synthesize column = _column;
@synthesize selected = _selected;



- (void)dealloc
{
   //BBDEALLOC();
}

- (void)setthumbnailImage:(UIImage *)thumbnail
{
    //BBINFO(@"@@@@@@@@   %f--%f", thumbnail.size.width, thumbnail.size.height);
    _imgeView.image = thumbnail;
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
    }
    return self;
}

#pragma mark setter/getter

- (void)setSelected:(BOOL)selected
{
    if(_selected != selected)
    {
        //kvo compliant notifications
        [self willChangeValueForKey:kPHOTO_SELECTED];
        _selected = selected;
        [self didChangeValueForKey:kPHOTO_SELECTED];
    }
    [self setNeedsDisplay];
}



#pragma mark event

- (void)userDidTapAction:(UITapGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        self.selected = !self.selected;
    }
}

@end
