//
//  TextCell.m
//  helpevernote
//
//  Created by bob on 4/12/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "TextCell.h"

@implementation TextTableCell
@synthesize fontImg;
@synthesize lblName = lblName_;
@synthesize lblText = lblText_;
@synthesize myaccessView;

- (void)dealloc
{
    self.myaccessView = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //  int iHeight = 30;
        int iLblWidth = [BBAutoSize screenWidth] - 120;
        int iTotalWidht = [BBAutoSize screenWidth] - 40;
        int iSpace = 20;
        int iFontSize = 14 * fScr_Scale;
        int iTopsapce = 14;
        int iFontIcon = 25 * fScr_Scale;
        
        self.fontImg = [[FontImge alloc] initWithFrame:CGRectMake(iSpace, (40 - iFontIcon) / 2 + 3, iFontIcon + 5, iFontIcon)];
        [self addSubview:self.fontImg];
        
        lblName_ = [[UILabel alloc] initWithFrame:CGRectMake(iSpace + iFontIcon + 5, iTopsapce, iLblWidth, iFontSize + 3)];
        [lblName_ setFont:[UIFont systemFontOfSize:iFontSize]];
        [lblName_ setTextColor:[UIColor blackColor]];
        [lblName_ setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblName_];
        
        lblText_ = [[UILabel alloc] initWithFrame:CGRectMake(iLblWidth + iSpace, iTopsapce, iTotalWidht - iLblWidth - iSpace,iFontSize)];
        [lblText_ setTextAlignment:NSTextAlignmentRight];
        [lblText_ setFont:[UIFont systemFontOfSize:iFontSize]];
        [lblText_ setBackgroundColor:[UIColor clearColor]];
        [lblText_ setTextColor:[UIColor lightGrayColor]];
        [self addSubview:lblText_];
        
//        UIImage *rateImg = [UIImage imageNamed:@"rate_us_remainder.png"];
//        self.redCircleView  = [[UIImageView alloc] initWithFrame:CGRectMake(iSpace - 5, iTopsapce - 3, rateImg.size.width * 3 / 4, rateImg.size.height * 3 / 4)];
//        [self.redCircleView setImage:rateImg];
//        [self addSubview:self.redCircleView];
//        self.redCircleView.hidden = YES;
        
        UIImage *img = [UIImage imageNamed:@"setting_access.png"];
        self.myaccessView = [[UIImageView alloc] initWithFrame:CGRectMake(iTotalWidht, iTopsapce, img.size.width, img.size.height)];
        [self.myaccessView setImage:img];
        [self addSubview:self.myaccessView];
    }
    return self;
}
@end




@implementation PersonTextTableCell
@synthesize lblName = lblName_;
@synthesize lblText = lblText_;
@synthesize myaccessView;

- (void)dealloc
{
    self.myaccessView = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //  int iHeight = 30;
        int iLblWidth = 100 * fScr_Scale;
        int iTotalWidht = [BBAutoSize screenWidth] - 40;
        int iSpace = 20;
        int iFontSize = 14 * fScr_Scale;
        int iTopsapce = 17;
        lblName_ = [[UILabel alloc] initWithFrame:CGRectMake(iSpace, iTopsapce, iLblWidth, iFontSize + 3)];
        [lblName_ setFont:[UIFont systemFontOfSize:iFontSize]];
        [lblName_ setTextColor:[UIColor darkGrayColor]];
        [lblName_ setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblName_];
        
        lblText_ = [[UILabel alloc] initWithFrame:CGRectMake(iLblWidth + iSpace, iTopsapce, iTotalWidht - iLblWidth - iSpace,iFontSize + 3)];
        [lblText_ setTextAlignment:NSTextAlignmentRight];
        [lblText_ setFont:[UIFont systemFontOfSize:iFontSize - 2 * fScr_Scale]];
        [lblText_ setBackgroundColor:[UIColor clearColor]];
        [lblText_ setTextColor:[UIColor grayColor]];
        [self addSubview:lblText_];
        
        UIImage *img = [UIImage imageNamed:@"setting_access.png"];
        self.myaccessView = [[UIImageView alloc] initWithFrame:CGRectMake(iTotalWidht, iTopsapce, img.size.width, img.size.height)];
        [self.myaccessView setImage:img];
        [self addSubview:self.myaccessView];
    }
    return self;
}
@end


@implementation EvernoteTableCell
@synthesize lblName = lblName_;
@synthesize lblText = lblText_;
//@synthesize myaccessView;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //  int iHeight = 30;
        int iLblWidth = 200 * fScr_Scale;
//        int iTotalWidht = 280 * fScr_Scale;
        int iSpace = 20;
        int iFontSize = 14 * fScr_Scale;
        int iTopsapce = 10;
        
        UIImage *everimg = [UIImage imageNamed:@"evernote"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(iSpace, 5, everimg.size.width, everimg.size.height)];
        [imgView setImage:everimg];
        [self addSubview:imgView];
        
        
        lblName_ = [[UILabel alloc] initWithFrame:CGRectMake(iSpace + everimg.size.width + 10 * fScr_Scale, iTopsapce, iLblWidth, iFontSize + 3)];
        [lblName_ setFont:[UIFont systemFontOfSize:iFontSize + 4 * fScr_Scale]];
        [lblName_ setTextColor:[UIColor darkGrayColor]];
        [lblName_ setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblName_];
        
        lblText_ = [[UILabel alloc] initWithFrame:CGRectMake(iSpace + everimg.size.width + 10 * fScr_Scale, iTopsapce + 30, iLblWidth,iFontSize + 3)];
        [lblText_ setTextAlignment:NSTextAlignmentLeft];
        [lblText_ setFont:[UIFont systemFontOfSize:iFontSize - 2 * fScr_Scale]];
        [lblText_ setBackgroundColor:[UIColor clearColor]];
        [lblText_ setTextColor:[UIColor grayColor]];
        [self addSubview:lblText_];
//        
//        UIImage *img = [UIImage imageNamed:@"setting_access.png"];
//        self.myaccessView = [[UIImageView alloc] initWithFrame:CGRectMake(iTotalWidht, iTopsapce, img.size.width, img.size.height)];
//        [self.myaccessView setImage:img];
//        [self addSubview:self.myaccessView];
    }
    return self;
}
@end

