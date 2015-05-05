//
//  DeleteBtn.m
//  M6s
//
//  Created by Apple on 13-5-28.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "DeleteBtn.h"
#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
#import "BBMisc.h"
#import "FileManagerController.h"
#import "BBUserDefault.h"

@implementation DeleteBtn
@synthesize btnDelegate;
@synthesize strPath;

- (id)initWithImage:(UIImage *)img  andPath:(NSString *)str
{
    if(self = [super init])
    {
        self.strPath = str;
        int iMargin = 8;
        [self setFrame:CGRectMake(0, 0, PHOTO_SELECT_RECT_H + iMargin, PHOTO_SELECT_RECT_H + iMargin)];
        UIImageView *imgeView = [[UIImageView alloc] initWithFrame:CGRectMake(iMargin, iMargin, PHOTO_SELECT_RECT_H, PHOTO_SELECT_RECT_H)];
        imgeView.contentMode = UIViewContentModeScaleAspectFill;
        imgeView.clipsToBounds = YES;
        CALayer *layer = [imgeView layer];
        layer.borderColor = [[UIColor blackColor] CGColor];
        layer.borderWidth = 2.0f;
        layer.shadowColor = [[UIColor colorWithRed:198/255.0 green:126/255.0 blue:151/255.0 alpha:1.0] CGColor];
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowOpacity = 0.8;
        layer.shadowRadius = 2;
        if(img)
        {
            imgeView.image = img;
        }
        else
        {
            imgeView.image = [UIImage imageWithContentsOfFile:self.strPath];
        }
        imgeView.image = img;
        [self addSubview:imgeView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage imageNamed:@"photo_select_close"];
        [btn setFrame:CGRectMake(0, 0, 20, 20)];
        [btn setImage:img forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)btnPressed:(id)sender
{
    if(self.btnDelegate && [self.btnDelegate respondsToSelector:@selector(deleteBtnDidTaped:)])
    {
        [self.btnDelegate deleteBtnDidTaped:self.strPath];
    }
}

@end

@implementation SelectedImageScrollView
@synthesize arrayImg;
@synthesize arrayView;


- (id)initWithFrame:(CGRect)frame maxCount:(int)max
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[BBSkin shareSkin].bgColor];
        self.userInteractionEnabled = YES;
        lblMax_ = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 150, 12)];
        [lblMax_ setBackgroundColor:[UIColor clearColor]];
        [lblMax_ setFont:[UIFont systemFontOfSize:10]];
        [lblMax_ setTextColor:[UIColor whiteColor]];
        [self addSubview:lblMax_];
        
        iMax_ = max;
        
        scrView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 16, SCR_WIDTH, self.frame.size.height)];
        [scrView_ setContentSize:CGSizeMake(SCR_WIDTH, frame.size.height)];
        [self addSubview:scrView_];
        self.arrayImg = [NSMutableArray arrayWithCapacity:8];
        self.arrayView = [NSMutableArray arrayWithCapacity:8];
    }
    return self;
}

- (NSString *)checkIsSaved:(NSString *)strName
{
    if(iMax_ <= self.arrayImg.count)
        return NSLocalizedString(@"max number have reached!", nil);
    BOOL bFind = NO;
    for (BImage *bimg in self.arrayImg) {
        NSString *str = bimg.assetPath;
        if([str isEqualToString:strName])
        {
            bFind = YES;
            break;
        }
    }
    if(bFind)
    {
        return  NSLocalizedString(@"saved!", nil);
    }
    return NSLocalizedString(@"saving...", nil) ;
}

- (BOOL)addImage:(UIImage *)img thumbnail:(UIImage *)thumbImage bigImageData:(NSData *)data andName:(NSString *)strName toPath:(NSString *)strPath
{
    BOOL bFind = NO;
    for (BImage *bimg in self.arrayImg) {
        NSString *str = bimg.assetPath;
        if([str isEqualToString:strName])
        {
            bFind = YES;
            break;
        }
    }
    if(bFind)
    {
       if(iMax_ <= self.arrayImg.count)
           return NO;
        else
            return YES;
    }
    BBINFO(@"====== %@", strName);
    
  
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        if(self.saveDelegate && [self.saveDelegate respondsToSelector:@selector(saveImageBegin:)])
        {
            [self.saveDelegate saveImageBegin:NSLocalizedString(@"saving", nil)];
        }

        BImage *bimg = [BBMisc saveAssetImageToSand:data smlImag:img path:strPath isContent:NO];
        if(bimg)
        {
            BBINFO(@"save %@ successful!", strName);
            bimg.assetPath = strName;
            [self.arrayImg addObject:bimg];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            DeleteBtn *delBtn = [[DeleteBtn alloc] initWithImage:thumbImage andPath:strName];
            delBtn.btnDelegate = self;
            [arrayView  addObject:delBtn];
            [scrView_ addSubview:delBtn];
            [self updateContentSize:YES];
        });
        if(self.saveDelegate && [self.saveDelegate respondsToSelector:@selector(saveImageCompleted:)])
        {
            [self.saveDelegate saveImageCompleted:NSLocalizedString(@"saved", nil)];
        }
    });
    return YES;
}

- (void)updateContentSize:(BOOL)bShouldScroll
{
    int iMargin = 10;
    int iW = (PHOTO_SELECT_RECT_H + iMargin)* arrayImg.count;
    BBINFO(@"======= %d", iW);
    iW += iMargin;
    if (iW > SCR_WIDTH)
    {
        [scrView_ setContentSize:CGSizeMake(iW, self.frame.size.height)];
//        CGRect rct = self.frame;
//        rct.origin.x = iW - SCR_WIDTH;
//        [scrView_ scrollRectToVisible:rct animated:YES];
        if (bShouldScroll) {
            int offset = 0;
            offset = iW - SCR_WIDTH;
            BBINFO(@"======= %d", offset);
            [scrView_ setContentOffset:CGPointMake(offset, 0)];
        }

    }
    else
    {
        [scrView_ setContentSize:CGSizeMake(SCR_WIDTH, self.frame.size.height)];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        int i = 0;
        for (DeleteBtn *delBtn in arrayView)
        {
            CGRect rct = delBtn.frame;
            [delBtn setFrame:CGRectMake(iMargin + (PHOTO_SELECT_RECT_H + iMargin) * i, 0, rct.size.width, rct.size.height)];
            i ++;
        }
    }];

    [lblMax_ setText:[NSString stringWithFormat:NSLocalizedString(@"have %d, rest %d", nil), arrayImg.count, iMax_ -arrayImg.count]];
}

- (void)deleteBtnDidTaped:(NSString *)str
{
    BOOL bFind = NO;
    int i =0;
    for(i = 0; i < self.arrayImg.count; i++)
    {
        
        BImage *bimg = [self.arrayImg objectAtIndex:i];
        NSString *strName = bimg.assetPath;
        if([strName isEqualToString:str])
        {
            bFind = YES;
            break;
        }
    }
    if(bFind)
    {
        [self removeViewAtIndexes:i];
    }
}

- (void)removeViewAtIndexes:(int)index
{
    if(self.saveDelegate && [self.saveDelegate respondsToSelector:@selector(saveImageBegin:)])
    {
        //[self.saveDelegate saveImageBegin:NSLocalizedString(@"deleting", nil)];
    }
    DeleteBtn *delbtn = [self.arrayView objectAtIndex:index];
    [UIView animateWithDuration:0.1 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        delbtn.alpha = 0.f;
    } completion:^(BOOL finished){
        BImage *bimg = [self.arrayImg objectAtIndex:index];
        [delbtn removeFromSuperview];
        [self.arrayView removeObjectAtIndex:index];
        [self.arrayImg removeObjectAtIndex:index];
        [self updateContentSize:NO];
   
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            [BBMisc deleteImageFileOfCoredata:bimg];
            if(self.saveDelegate && [self.saveDelegate respondsToSelector:@selector(saveImageCompleted:)])
            {
                //[self.saveDelegate saveImageCompleted:NSLocalizedString(@"deleted", nil)];
            }
        });
    }];

}



- (void)saveAllImage
{
    [BBUserDefault saveImageFormAblum:self.arrayImg];
}
@end

