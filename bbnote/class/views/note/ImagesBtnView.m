//
//  ImagesBtnView.m
//  bbnote
//
//  Created by Apple on 13-4-9.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "ImagesBtnView.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+SCaleImage.h"
#import "FileManagerController.h"

@implementation ImageButton
@synthesize bimage = _bimage;
@synthesize strNotePath ;


- (id)initWithImage:(BImage *)bmage notePath:(NSString *)strPath
{
    self = [super init];
    if(self)
    {
        self.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] CGColor];
        self.layer.borderWidth = 2.0f;
        self.layer.shadowColor = [UIColor colorWithRed:198/255.0 green:126/255.0 blue:151/255.0 alpha:1.0].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 2;
        self.strNotePath = strPath;
        self.bimage = bmage;
    }
    return self;
}

- (void)setBimage:(BImage *)bimage
{
    if(_bimage != bimage)
    {
        _bimage = bimage;
        if(_bimage)
        {
            float fHeight = [_bimage.height floatValue];
            float fWidth = [_bimage.width floatValue];
            UIImage *img = [UIImage imageWithContentsOfFile:[self.strNotePath stringByAppendingPathComponent:_bimage.data_path]];
            fHeight = img.size.height;
            fWidth = img.size.width;
            if(fHeight > fWidth)
            {
                float fScale = fWidth / IMAGE_BUTTON_WIDTH;
                float fH = fHeight / fScale;
                img = [img scaleToSize:CGSizeMake(IMAGE_BUTTON_WIDTH, fH)];
            }
            else
            {
                float fScale = fHeight / IMAGE_BUTTON_WIDTH;
                float fW = fWidth / fScale;
                img = [img scaleToSize:CGSizeMake(fW, IMAGE_BUTTON_WIDTH)];
            }
            [self setImage:img forState:UIControlStateNormal];
            [self setContentMode:UIViewContentModeCenter];
            [self setFrame:CGRectMake(0, 0, IMAGE_BUTTON_WIDTH, IMAGE_BUTTON_WIDTH)];
        }
    }
}

@end


@implementation ImagesBtnView
@synthesize strNotePath;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    iSpace_ = 4;
    int iSpace = SCR_WIDTH - IMAGE_BUTTON_WIDTH * 4;
    iLeftSapce_ = (iSpace - iSpace_ * 5) / 2;
    self = [super initWithFrame:frame];
    if (self) {
        mutArray_ = [NSMutableArray arrayWithCapacity:8];
        [self addDefaultImage];
    }
    return self;
}

- (id)initWithObjects:(NSArray *)array
{
    iSpace_ = 4;
    int iSpace = SCR_WIDTH - IMAGE_BUTTON_WIDTH * 4;
    iLeftSapce_ = (iSpace - iSpace_ * 5) / 2;
    self = [super initWithFrame:CGRectMake(iLeftSapce_, 0, SCR_WIDTH - iLeftSapce_ * 2, IMAGE_BUTTON_WIDTH + iSpace_ * 2)];
    if(self)
    {
        mutArray_ = [NSMutableArray arrayWithArray:array];;
        [self addDefaultImage];
    }
    return self;
}

- (void)addDefaultImage
{
    BImage *bimg = [[BImage alloc] init];
    bimg.height = [NSNumber numberWithInt:67];
    bimg.width = [NSNumber numberWithInt:66];
    bimg.data_small_path = @"record_add.png";
    addImgBtn_ = [[ImageButton alloc] initWithImage:bimg notePath:self.strNotePath];
    [addImgBtn_ setBackgroundImage:[UIImage imageNamed:@"record_add.png"] forState:UIControlStateHighlighted];
    [addImgBtn_ setBackgroundImage:[UIImage imageNamed:@"record_add_hl.png"] forState:UIControlStateNormal];
    //[addImgBtn_ setTitle:@"picture" forState:UIControlStateNormal];
    [addImgBtn_ addTarget:self action:@selector(addImageBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addImgBtn_];
    [self adjustPostion];
}

- (void)deleteImageObject:(BImage *)bimge
{
    for (ImageButton *imgBtn in mutArray_)
    {
        if(imgBtn.bimage == bimge)
        {
            BBINFO(@"delete imgbtn successful");
            [mutArray_ removeObject:imgBtn];
            [imgBtn removeFromSuperview];
            break;
        }
    }
    [self adjustPostion];
}

- (void)addImageObject:(BImage *)bimge
{
    ImageButton *imgBtn = [[ImageButton alloc] initWithImage:bimge notePath:self.strNotePath];
    [imgBtn addTarget:self action:@selector(pictureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mutArray_ addObject:imgBtn];
    [self addSubview:imgBtn];
    [self adjustPostion];
}

- (void)removeImage:(NSString *)str
{
    if(!str || [str isEqual:[NSNull null]])
        return;
    for (ImageButton *imgbtn in mutArray_) {
        if([imgbtn.bimage.data_path isEqualToString:str])
        {
            [FileManagerController removeFile:imgbtn.bimage.data_path];
//            [FileManagerController removeFile:imgbtn.bimage.data_small_path];
            [imgbtn removeFromSuperview];
            [mutArray_ removeObject:imgbtn];
            [self adjustPostion];
            break;
        }
    }
}

- (void)adjustPostion
{
    float fY = self.frame.origin.y;
    if(mutArray_.count >= 4)
    {
        [self setFrame:CGRectMake(iLeftSapce_, fY, SCR_WIDTH, (IMAGE_BUTTON_WIDTH + iSpace_ * 2) * 2)];
    }
    else
    {
        [self setFrame:CGRectMake(iLeftSapce_, fY, SCR_WIDTH, IMAGE_BUTTON_WIDTH + iSpace_ * 2)];
    }
    fY = 0;
    fY += iSpace_;
    int iCount = mutArray_.count;
    int i = 0;
    for (; i < 4; i++) {
        if(i > iCount - 1)
            break;
        ImageButton *imgBtn = [mutArray_ objectAtIndex:i];
        [imgBtn setFrame:CGRectMake(iSpace_ + IMAGE_BUTTON_WIDTH * i, fY, IMAGE_BUTTON_WIDTH, IMAGE_BUTTON_WIDTH)];
    }
    if(i <= 3)
    {
        [addImgBtn_ setHidden:NO];
        [addImgBtn_ setFrame:CGRectMake(iSpace_ + IMAGE_BUTTON_WIDTH * i, fY, IMAGE_BUTTON_WIDTH, IMAGE_BUTTON_WIDTH)];
    }
    else
    {
        fY += IMAGE_BUTTON_WIDTH + iSpace_ * 2;
        i = 0;
        for (; i < 4; i++) {
            if(i > iCount - 1 - 4)
                break;
            ImageButton *imgBtn = [mutArray_ objectAtIndex:i + 4];
            [imgBtn setFrame:CGRectMake(iSpace_ + IMAGE_BUTTON_WIDTH * i, fY, IMAGE_BUTTON_WIDTH, IMAGE_BUTTON_WIDTH)];
        }
        if(i <= 3)
        {
            [addImgBtn_ setHidden:NO];
            [addImgBtn_ setFrame:CGRectMake(iSpace_ + IMAGE_BUTTON_WIDTH * i, fY, IMAGE_BUTTON_WIDTH, IMAGE_BUTTON_WIDTH)];
        }
        else
        {
            [addImgBtn_ setHidden:YES];
        }
    }
    
  
    if(self.delegate && [self.delegate respondsToSelector:@selector(adjustViewFrame)])
    {
        [self.delegate adjustViewFrame];
    }
}

- (void)addImageBtnPressed:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(addImageBtnPressed)])
    {
        [self.delegate addImageBtnPressed];
    }
}

- (void)pictureBtnPressed:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(pictureBtnPressed:)])
    {
        [self.delegate pictureBtnPressed:sender];
    }
}

@end
