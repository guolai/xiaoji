//
//  CardCell.m
//  Zine
//
//  Created by bob on 12/18/13.
//  Copyright (c) 2013 aura marker stdio. All rights reserved.
//

#import "SmartCardCell.h"
#import "DataModel.h"
#import "NSDate+String.h"
#import "UIImage+Extensions.h"
#import "BBUserDefault.h"
#import "UIImage+SCaleImage.h"
#import "ImageCacheManager.h"


#define kCARD_SELECTED @"isCardSelected"




@implementation SmartCardCell
@synthesize delegate;
@synthesize arrayViews;
@synthesize iAssetsPerRow;

- (void)dealloc
{
    //    BBDEALLOC();
    [self stopObserving];
    self.arrayViews = nil;
    self.delegate = nil;
}

- (id)initWithReuseIdentifier:strIndefi withColumn:(int)iColumn
{
    if((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndefi]))
    {
        //        BBDEALLOC();
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        self.iAssetsPerRow = iColumn;
        [self initColums];
    }
    return self;
}


- (void)initColums
{
    self.arrayViews = [NSMutableArray arrayWithCapacity:self.iAssetsPerRow];
    float fPadding = 1;
    float fWidth = roundf((SCR_WIDTH - fPadding * (self.iAssetsPerRow - 1)) / self.iAssetsPerRow);
    
    CGRect rct = CGRectMake(0, fPadding, fWidth, fWidth * 480 / 320);
    
    for(int i = 0; i < iAssetsPerRow; i++)
    {
        BBCardViewColumn *briefViewColumn = [[BBCardViewColumn alloc] initWithFrame:rct];
        briefViewColumn.column = i;
        [briefViewColumn addObserver:self forKeyPath:kCARD_SELECTED options:NSKeyValueObservingOptionNew context:NULL];
        [self addSubview:briefViewColumn];
        [self.arrayViews addObject:briefViewColumn];
        rct.origin.x = rct.origin.x + rct.size.width + fPadding;
    }
}

- (void)stopObserving
{
    for (BBCardViewColumn *briefViewColumn in self.arrayViews) {
        [briefViewColumn removeObserver:self forKeyPath:kCARD_SELECTED context:NULL];
        //[briefViewColumn removeFromSuperview];
    }
}

- (void)setCellCardViewsArray:(NSArray *)cellBriefViewsArray;
{
    NSAssert(cellBriefViewsArray.count <= self.arrayViews.count, @"error");
    int iIndex = 0;
    for(SmartObject *smartObject in cellBriefViewsArray)
    {
        BBCardViewColumn *briefViewColumn = (BBCardViewColumn *)[self.arrayViews objectAtIndex:iIndex];
        briefViewColumn.smartObject = smartObject;
        briefViewColumn.hidden = NO;
        iIndex ++;
    }
    for (int i =iIndex; i < self.arrayViews.count; i++) {
        BBRiefViewColumn *briefViewColumn = (BBRiefViewColumn *)[self.arrayViews objectAtIndex:i];
        briefViewColumn.hidden = YES;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([object isMemberOfClass:[BBCardViewColumn class]])
    {
        BBCardViewColumn *column = (BBCardViewColumn *)object;
        if([self.delegate respondsToSelector:@selector(smartcardTableViewCell:didSelectAsset:atColumn:)])
        {
            [self.delegate smartcardTableViewCell:self didSelectAsset:YES atColumn:column.column];
        }
    }
}

@end

@implementation BBCardViewColumn
@synthesize column = _column;
@synthesize selected = _selected;
@synthesize smartObject = _smartObject;


- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.clipsToBounds  = YES;
        [_imgView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_imgView];

        
        UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapAction:)];
        [self addGestureRecognizer:tapGst];
    }
    return self;
}


-(void)setSmartObject:(SmartObject *)smartObject
{
    _smartObject = smartObject;
    NSString *strPath = smartObject.strNotePath;
    strPath = [strPath stringByAppendingPathComponent:smartObject.strFileName];
    self.strLoadingPath = strPath;
    NSString *blockPath = strPath;
    UIImage *tmpImage = [[ImageCacheManager shareInstance] getCachedImageFromFilePath:strPath];
    if (tmpImage) {
        [_imgView setImage:tmpImage];
    }
    else
    {
        //    [_imgView setImage:nil];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *img = [UIImage imageWithContentsOfFile:blockPath];
            
            UIImage *scaleImg = [img clipImageToScaleSize:_imgView.bounds.size];
            [[ImageCacheManager shareInstance] saveImageToCache:scaleImg filePath:blockPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                if([self.strLoadingPath isEqualToString:blockPath])
                {
                    [_imgView setImage:scaleImg];
                }
            });
            
        });

    }
    
    
//    dispatch_queue_t queue = dispatch_queue_create("com.auramarker.loadfile", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        UIImage *img = [UIImage imageWithContentsOfFile:blockPath];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(img)
//            {
//                [_imgView setImage:img];
//            }
//            else
//            {
//                [_imgView setImage:nil];
//            }
//        });
//    });
}

#pragma mark setter/getter

- (void)setSelected:(BOOL)selected
{
    if(_selected != selected)
    {
        //kvo compliant notifications
        [self willChangeValueForKey:kCARD_SELECTED];
        _selected = selected;
        [self didChangeValueForKey:kCARD_SELECTED];
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


