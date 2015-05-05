//
//  HomeTileView.m
//  helpevernote
//
//  Created by bob on 4/12/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "HomeTileView.h"
#import "UIImage+ImageEffects.h"

@interface HomeTileView ()
@property (nonatomic, strong)UILabel *lblEntr;
@property (nonatomic, strong)UILabel *lblEntrCount;
@property (nonatomic, strong)UILabel *lblDays;
@property (nonatomic, strong)UILabel *lblDaysCount;
@property (nonatomic, strong)UILabel *lblWeeks;
@property (nonatomic, strong)UILabel *lblWeeksCount;
@property (nonatomic, strong)UILabel *lblToday;
@property (nonatomic, strong)UILabel *lblTodayCount;

@end


@implementation HomeTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *strImg = [[BBSkin shareSkin] getHomeTileImg];
        if(!strImg)
        {
            strImg = @"profile_cover_bg";
        }
        UIImage *bgImg = [UIImage imageNamed:strImg];
        if(!bgImg)
        {
            bgImg = [UIImage imageNamed:@"profile_cover_bg"];
        }
        [self setImage:bgImg];
        float fLeftSpace = 20 * fScr_Scale;
        float fTitileHeight = 10 * fScr_Scale;
        float fCountHeight = 14 * fScr_Scale;
        float fMargin = 2;
        CGFloat fViewHeight = 10 + fTitileHeight + fCountHeight + fMargin;
        float fTop = self.frame.size.height - fViewHeight;
        float fWidth = (self.frame.size.width - fLeftSpace * 2) / 4;
        float fScale = [[UIScreen mainScreen] scale];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, fTop, self.frame.size.width, fViewHeight)];
        CGFloat fImgHeight = fViewHeight * bgImg.size.width / self.frame.size.width;
        UIImage *tmpImg = [bgImg cropImageWithBounds:CGRectMake(0, (int)(bgImg.size.height - fImgHeight) * fScale, bgImg.size.width * fScale, (int)fImgHeight * fScale)];
        imgView.image = [tmpImg applySubtleEffect];
//        imgView.image = [bgImg applyExtraLightEffect];
//        [imgView setClipsToBounds:YES];
//        [imgView setContentMode:UIViewContentModeBottom];
//        [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [imgView.layer setCornerRadius:5.0];
        [self addSubview:imgView];
        
        NSMutableArray *mulArray = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(fLeftSpace + fWidth * i, fTop, fWidth, fCountHeight)];
            [lbl setTextColor:[BBSkin shareSkin].titleBgColor];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl setFont:[UIFont boldSystemFontOfSize:fCountHeight]];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [self addSubview:lbl];
            [lbl setText:@"0"];
            [mulArray addObject:lbl];
        }
        self.lblEntrCount = [mulArray objectAtIndex:0];
        self.lblDaysCount = [mulArray objectAtIndex:1];
        self.lblWeeksCount = [mulArray objectAtIndex:2];
        self.lblTodayCount = [mulArray objectAtIndex:3];
        NSArray *titleArray = @[NSLocalizedString(@"ENTRIES", nil), NSLocalizedString(@"DAYS", nil), NSLocalizedString(@"THIS WEEK", nil), NSLocalizedString(@"TODAY", nil)];
        fTop += fCountHeight;
        fTop += fMargin;
        for (int i = 0; i < 4; i++) {
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(fLeftSpace + fWidth * i, fTop, fWidth, fCountHeight)];
            [lbl setTextColor:[UIColor blackColor]];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setFont:[UIFont systemFontOfSize:fTitileHeight]];
            [lbl setText:[titleArray objectAtIndex:i]];
            [self addSubview:lbl];
//            [mulArray addObject:lbl];
        }
    }
    return self;
}

- (void)setEntriesCount:(int)iValue
{
    if(iValue > 1000)
    {
        self.lblEntrCount.text = [NSString stringWithFormat:@"%.2fk", iValue / 1000.0];
    }
    else if(iValue > 1000 * 1000)
    {
         self.lblEntrCount.text = [NSString stringWithFormat:@"%.2fm", iValue / (1000.0 * 1000.0)];
    }
    self.lblEntrCount.text = [NSString stringWithFormat:@"%d", iValue];
}

- (void)setDaysCount:(int)iValue
{
    if(iValue > 1000)
    {
        self.lblDaysCount.text = [NSString stringWithFormat:@"%.2fk", iValue / 1000.0];
    }
    self.lblDaysCount.text = [NSString stringWithFormat:@"%d", iValue];
}

- (void)setWeeksCount:(int)iValue
{
    if(iValue > 1000)
    {
        self.lblWeeksCount.text = [NSString stringWithFormat:@"%.2fk", iValue / 1000.0];
    }
    self.lblWeeksCount.text = [NSString stringWithFormat:@"%d", iValue];
}

- (void)setTodayCount:(int)iValue
{
    if(iValue > 1000)
    {
        self.lblTodayCount.text = [NSString stringWithFormat:@"%.2fk", iValue / 1000.0];
    }
    self.lblTodayCount.text = [NSString stringWithFormat:@"%d", iValue];
}

@end
