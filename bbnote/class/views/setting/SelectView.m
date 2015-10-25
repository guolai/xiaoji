//
//  SelectView.m
//  bbnote
//
//  Created by zhuhb on 13-6-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "SelectView.h"
#import "Constant.h"
#import "NSString+UIColor.h"
#import "BBSkin.h"

@implementation SelectBtnView
@synthesize selectView = _selectView;



- (id)initWithFrame:(CGRect)frame withStrColor:(NSString *)strColor
{
    if(self = [super initWithFrame:frame])
    {
        UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnPressed)];
        [self addGestureRecognizer:tapGst];
        int iMargin = 4;
        UIImageView *imgeView = [[UIImageView alloc] initWithFrame:CGRectMake(iMargin, iMargin, frame.size.width - iMargin * 2, frame.size.height - iMargin * 2)];
        imgeView.contentMode = UIViewContentModeScaleAspectFill;
        [imgeView setBackgroundColor:[strColor getColorFromString]];
        [self addSubview:imgeView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withColor:(UIColor *)color
{
    if(self = [super initWithFrame:frame])
    {
        UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnPressed)];
        [self addGestureRecognizer:tapGst];
        int iMargin = 4;
        UIImageView *imgeView = [[UIImageView alloc] initWithFrame:CGRectMake(iMargin, iMargin, frame.size.width - iMargin * 2, frame.size.height - iMargin * 2)];
        imgeView.contentMode = UIViewContentModeScaleAspectFill;
        [imgeView setBackgroundColor:color];
        [self addSubview:imgeView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image
{
    if(self = [super initWithFrame:frame])
    {
        UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSkinType)];
        [self addGestureRecognizer:tapGst];
        int iMargin = 4;
        UIImageView *imgeView = [[UIImageView alloc] initWithFrame:CGRectMake(iMargin, iMargin, frame.size.width - iMargin * 2, frame.size.height - iMargin * 2)];
        imgeView.contentMode = UIViewContentModeScaleAspectFill;
        [imgeView setImage:image];
        [self addSubview:imgeView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withBgImage:(UIImage *)image
{
    if(self = [super initWithFrame:frame])
    {
        UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnPressed)];
        [self addGestureRecognizer:tapGst];
        int iMargin = 4;
        UIImageView *imgeView = [[UIImageView alloc] initWithFrame:CGRectMake(iMargin, iMargin, frame.size.width - iMargin * 2, frame.size.height - iMargin * 2)];
        imgeView.contentMode = UIViewContentModeScaleAspectFill;
        imgeView.clipsToBounds = YES;
        [imgeView setImage:image];
        [self addSubview:imgeView];
    }
    return self;
}

- (void)btnPressed
{
    if(self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(didSelectAColor:)])
    {
        [self.selectDelegate didSelectAColor:self.tag - CELL_TAG];
    }
}

- (void)changeSkinType
{
    if(self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(didChangeSkinType:)])
    {
        [self.selectDelegate didChangeSkinType:self.tag - CELL_TAG];
    }
}

- (UIImageView *)selectView
{
    if(!_selectView)
    {
        UIImage *img = [UIImage imageNamed:@"skin_check.png"];
        CGSize size = self.frame.size;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width - img.size.width, size.height - img.size.height, img.size.width, img.size.height)];
        [imgView setImage:img];
        imgView.hidden = YES;
        [self addSubview:imgView];
        
        _selectView = imgView;
    }
    return _selectView;
}

@end

@implementation SelectView
@synthesize arraySelctView;
@synthesize arrayColors;
@synthesize selectDelegate;

- (id)initWithFrame:(CGRect)frame withColors:(NSArray *)array cloumn:(int)icloumn
{
    if(self = [super initWithFrame:frame])
    {
        int iRow = (array.count + icloumn - 1) / icloumn;
        int iMargin = 9;
        if(icloumn >= 6)
            iMargin = 0;
        float fWidth = frame.size.width - iMargin * (icloumn - 1);
        fWidth = fWidth / icloumn;
        self.arraySelctView = [NSMutableArray arrayWithCapacity:10];
        self.arrayColors = array;
        for (int i = 0; i < iRow; i++) {
            for (int j = 0; j < icloumn; j++) {
                int index = i * icloumn + j;
                if(index >= array.count)
                    break;
                CGRect rct = CGRectMake((fWidth + iMargin) * j, (fWidth + iMargin) * i, fWidth, fWidth);
                NSString *strColor = [self.arrayColors objectAtIndex:index];
                
                UIColor *color = [strColor getColorFromRGBA];
                SelectBtnView *selctview = [[SelectBtnView alloc] initWithFrame:rct withColor:color];
                selctview.tag = CELL_TAG + index;
                selctview.selectDelegate = self;
                 [self addSubview:selctview];
                [arraySelctView addObject:selctview];
            }
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withSkinImages:(NSArray *)array cloumn:(int)icloumn
{
    if(self = [super initWithFrame:frame])
    {
        int iRow = (array.count + icloumn - 1) / icloumn;
        int iMargin = 9;
        if(icloumn >= 6)
            iMargin = 0;
        float fWidth = frame.size.width - iMargin * (icloumn - 1);
        fWidth = fWidth / icloumn;
        self.arraySelctView = [NSMutableArray arrayWithCapacity:array.count];
        self.arrayColors = array;
        for (int i = 0; i < iRow; i++) {
            for (int j = 0; j < icloumn; j++) {
                int index = i * icloumn + j;
                if(index >= array.count)
                    break;
                CGRect rct = CGRectMake((fWidth + iMargin) * j, (fWidth + iMargin) * i, fWidth, fWidth);
                NSString *strimg = [array objectAtIndex:index];
                UIImage *img = [UIImage imageNamed:strimg];
                BBINFO(@"%@", img.debugDescription);
                SelectBtnView *selctview = [[SelectBtnView alloc] initWithFrame:rct withImage:img];
                selctview.tag = CELL_TAG + index;
                selctview.selectDelegate = self;
                [selctview setBackgroundColor:[UIColor whiteColor]];
                [self addSubview:selctview];
                [self.arraySelctView addObject:selctview];
            }
        }
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame withBgImages:(NSArray *)array cloumn:(int)icloumn
{
    if(self = [super initWithFrame:frame])
    {
        int iRow = (array.count + icloumn - 1) / icloumn;
        int iMargin = 9;
        if(icloumn >= 6)
            iMargin = 0;
        float fWidth = frame.size.width - iMargin * (icloumn - 1);
        fWidth = fWidth / icloumn;
        self.arraySelctView = [NSMutableArray arrayWithCapacity:10];
        self.arrayColors = array;
        for (int i = 0; i < iRow; i++) {
            for (int j = 0; j < icloumn; j++) {
                int index = i * icloumn + j;
                if(index >= array.count)
                    break;
                CGRect rct = CGRectMake((fWidth + iMargin) * j, (fWidth + iMargin) * i, fWidth, fWidth);
                NSString *strimg = [array objectAtIndex:index];
                UIImage *img = [UIImage imageNamed:strimg];
                SelectBtnView *selctview = [[SelectBtnView alloc] initWithFrame:rct withBgImage:img];
                selctview.tag = CELL_TAG + index;
                selctview.selectDelegate = self;
                [selctview setBackgroundColor:[UIColor whiteColor]];
                [self addSubview:selctview];
                [self.arraySelctView addObject:selctview];
            }
        }
    }
    
    return self;
}


- (void)didSelectAColor:(int)ivalue
{
    [self resetSelectView:ivalue];
    if(self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(didSelectAColor:)])
    {
        [self.selectDelegate didSelectAColor:ivalue];
    }

}

- (void)didChangeSkinType:(int)ivalue
{
    [self resetSelectView:ivalue];
    if(self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(didChangeSkinType:)])
    {
        [self.selectDelegate didChangeSkinType:ivalue];
    }
}

-(void)resetSelectView:(int)ivalue
{
    if(ivalue < 0 || ivalue > arraySelctView.count)
        return;
    for (SelectBtnView *view in arraySelctView) {
        view.selectView.hidden = YES;
    }
    SelectBtnView *view = [arraySelctView objectAtIndex:ivalue];
    view.selectView.hidden = NO;
}
@end
