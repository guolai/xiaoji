
//
//  HomeCell.m
//  bbnote
//
//  Created by Apple on 13-4-30.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "HomeCell.h"
#import "Constant.h"
#import "NSDate+String.h"
#import "NSString+Help.h"
#import "UIImage+SCaleImage.h"
#import "BBMisc.h"
#import "BBSkin.h"
#import "NSNumber+Sort.h"
#import "BBUserDefault.h"
#import "DataModel.h"


@implementation HomeCell
@synthesize brecord = _brecord;
@synthesize arrayImages = _arrayImages;
@synthesize arrayAudios = _arrayAudios;
@synthesize isLast;
@synthesize bcontent = _bcontent;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float fHeight = 100.0;
        arrayShare_ = [[NSArray alloc] initWithObjects:@"sns_sinaweibo.png",@"sns_tcweibo.png", @"sns_qqzone.png",  @"sns_weixin.png", nil];
        arrayImageView_ = [[NSMutableArray alloc] initWithCapacity:10];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //times
        imgViewTimes_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"historyVerticalLine.png"]];
        CGRect rct = [BBMisc getRect:CELL_LEFT_SPACE withPosY:0.0 withwidth:3.0 withHeight:fHeight];
        [imgViewTimes_ setFrame:rct];
        [self addSubview:imgViewTimes_];
        
        imgeViewBg_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_cell_bg.png"]];
        [imgeViewBg_  setFrame:CGRectMake(CELL_LEFT_SPACE, 0, SCR_WIDTH - CELL_LEFT_SPACE, fHeight)];
        [self addSubview:imgeViewBg_];
        
        float fy = 15.0;
        float fh = 14.0;
        lblDate_ = [[UILabel alloc] init];
        rct = [BBMisc getRect:CELL_LEFT_SPACE withPosY:fy withwidth:60 withHeight:fh];
        [lblDate_ setBackgroundColor:[UIColor clearColor]];
        [lblDate_ setFrame:rct];
        //[lblDate_ setText:@"05-01"];
        [lblDate_ setTextAlignment:NSTextAlignmentCenter];
        [lblDate_ setFont:[UIFont boldSystemFontOfSize:fh]];
        [lblDate_ setTextColor:[BBSkin shareSkin].bgTxtColor];
        [self addSubview:lblDate_];
        
        fy += fh;
        fh = 10.0;
        lblTime_ = [[UILabel alloc] init];
        rct = [BBMisc getRect:CELL_LEFT_SPACE withPosY:fy withwidth:40 withHeight:fh];
        [lblTime_ setBackgroundColor:[UIColor clearColor]];
        [lblTime_ setFrame:rct];
        //[lblTime_ setText:@"17:20"];
        [lblTime_ setTextAlignment:NSTextAlignmentCenter];
        [lblTime_ setFont:[UIFont boldSystemFontOfSize:fh]];
        [lblTime_ setTextColor:[BBSkin shareSkin].bgTxtColor];
        [self addSubview:lblTime_];
        
        fy += fh;
        fh = 40.0;
        imgViewMood_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"001.png"]];
        rct = [BBMisc getRect:CELL_LEFT_SPACE withPosY:fy withwidth:CELL_MOOD_WH withHeight:CELL_MOOD_WH];
        [imgViewMood_ setFrame:rct];
        [self addSubview:imgViewMood_];
        
        //row 2
        fy = CELL_TOP_SPACE;
        for (int i = 0; i < 4; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            CALayer *layer = [imgView layer];
            layer.borderColor = [CELLIMAGEBORER_COLOR CGColor];
            layer.borderWidth = 2.0f;
            layer.shadowColor = CELLIMAGEBORER_COLOR.CGColor;
            layer.shadowOffset = CGSizeMake(3, 3);
            layer.shadowOpacity = 0.8;
            layer.shadowRadius = 5;
            if(i == 0)
                layer.cornerRadius = 10;
            else
                layer.cornerRadius = 4;
            
            [imgView setContentMode:UIViewContentModeScaleAspectFit];
            [imgView setClipsToBounds:YES];
            {
                float fx = CELL_LEFT_SPACE + CELL_CMT_LEFT_SPACE;
                if(i == 0)
                {
                    [imgView setFrame:CGRectMake(fx, fy, CELL_CMT_WIDTH, CELL_BIG_IMAGE_HEIGHT)];
                    fy += CELL_BIG_IMAGE_HEIGHT;
                    fy += CELL_SML_IMAGE_MARGIN;
                }
                else
                {
                    fx += (CELL_SML_IMAGE_MARGIN + CELL_SML_IMAGE_WIDTH) * (i - 1);
                    [imgView setFrame:CGRectMake(fx, fy, CELL_SML_IMAGE_WIDTH, CELL_SML_IMAGE_HEIGHT)];
                }
            }
//            [imgView setImage:[UIImage imageNamed:@"01.jpg"]];
            [self addSubview:imgView];
            [arrayImageView_ addObject:imgView];
        }
        fy += CELL_SML_IMAGE_HEIGHT;
        fy += CELL_SML_IMAGE_MARGIN;
        lblContent_ = [[UILabel alloc] init];
        [lblContent_ setBackgroundColor:[UIColor clearColor]];
        [lblContent_ setFrame:CGRectMake( CELL_LEFT_SPACE + CELL_CMT_LEFT_SPACE, fy, CELL_CMT_WIDTH, 30)];
        [lblContent_ setNumberOfLines:0];
        [lblContent_ setTextAlignment:NSTextAlignmentLeft];
        [lblContent_ setLineBreakMode:NSLineBreakByTruncatingTail];
        [lblContent_ setFont:[UIFont systemFontOfSize:CELL_CMT_FONT_SIZE]];
        [lblContent_ setText:@"我很喜欢你了，你在做什么呢，会不会在想我呢"];
  
        [self addSubview:lblContent_];
        {
            fy += 30;
            fy += CELL_SML_IMAGE_MARGIN;
            viewMeia_ = [[UIView alloc] init];
            [viewMeia_ setFrame:CGRectMake(CELL_LEFT_SPACE + CELL_CMT_LEFT_SPACE, fy, CELL_CMT_WIDTH, CELL_OTHER_CMT_HEiGHT)];
            [self addSubview:viewMeia_];
            
            int ix = 10;
            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_audio.png"]];
            [imgV setFrame:CGRectMake(ix, (CELL_OTHER_CMT_HEiGHT - 14) / 2, 16, 14)];
            [viewMeia_ addSubview:imgV];
            
            ix += 20;
            lblAudioCount_ = [[UILabel alloc] init];
            [lblAudioCount_ setFrame:CGRectMake(ix, (CELL_OTHER_CMT_HEiGHT - 14) / 2, 16, 14)];
            [lblAudioCount_ setBackgroundColor:[UIColor clearColor]];
            [lblAudioCount_ setFont:[UIFont systemFontOfSize:CELL_OTHER_CMT_FONT_SIZE]];
            [lblAudioCount_ setText:@"4"];
            [viewMeia_ addSubview:lblAudioCount_];
            
            ix += 30;
            imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_photo.png"]];
            [imgV setFrame:CGRectMake(ix, (CELL_OTHER_CMT_HEiGHT - 14) / 2, 16, 14)];
            [viewMeia_ addSubview:imgV];
            
            ix += 20;
            lblImageCount_ = [[UILabel alloc] init];
            [lblImageCount_ setFrame:CGRectMake(ix, (CELL_OTHER_CMT_HEiGHT - 14) / 2, 16, 14)];
            [lblImageCount_ setBackgroundColor:[UIColor clearColor]];
            [lblImageCount_  setFont:[UIFont systemFontOfSize:CELL_OTHER_CMT_FONT_SIZE]];
            [lblImageCount_ setText:@"9"];
            [viewMeia_ addSubview:lblImageCount_];
            
            ix += 30;
            UILabel *lbl = [[UILabel alloc] init];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setFont:[UIFont systemFontOfSize:CELL_OTHER_CMT_FONT_SIZE]];
            [lbl setText:NSLocalizedString(@"share", nil)];
            [viewMeia_ addSubview:lbl];
            
            ix +=20;
            viewShare_ = [[UIView alloc] init];
            [viewShare_ setFrame:CGRectMake(ix,(CELL_OTHER_CMT_HEiGHT - 14) / 2, 80, 14)];
            [viewMeia_ addSubview:viewShare_];
            
            ix = 0;
            imgV = [[UIImageView alloc] init];
            [imgV setImage:[UIImage imageNamed:@"sns_sinaweibo.png"]];
            [imgV setFrame:CGRectMake(ix, 0, 12, 12)];
            [viewShare_ addSubview:imgV];
            
            int iShare = 14;
            ix += iShare;
            imgV = [[UIImageView alloc] init];
            [imgV setImage:[UIImage imageNamed:@"sns_tcweibo.png"]];
            [imgV setFrame:CGRectMake(ix, 0, 12, 12)];
            [viewShare_ addSubview:imgV];
            ix += iShare;
            imgV = [[UIImageView alloc] init];
            [imgV setImage:[UIImage imageNamed:@"sns_qqzone.png"]];
            [imgV setFrame:CGRectMake(ix, 0, 12, 12)];
            [viewShare_ addSubview:imgV];
            
            ix += iShare;
            imgV = [[UIImageView alloc] init];
            [imgV setImage:[UIImage imageNamed:@"sns_weixin.png"]];
            [imgV setFrame:CGRectMake(ix, 0, 12, 12)];
            [viewShare_ addSubview:imgV];
        
        }
        fy += CELL_OTHER_CMT_HEiGHT;
        fy += CELL_SML_IMAGE_MARGIN;
        {
            viewLoaction_ = [[UIView alloc] init];
            [viewLoaction_ setFrame:CGRectMake(CELL_LEFT_SPACE + CELL_CMT_LEFT_SPACE, fy, CELL_CMT_WIDTH, CELL_OTHER_CMT_HEiGHT)];
            [self addSubview:viewLoaction_];
            int ix = 10;
            UIImageView *imgV = [[UIImageView alloc] init];
            [imgV setFrame:CGRectMake(ix, 0, 14, 14)];
            [imgV setImage:[UIImage imageNamed:@"home_location.png"]];
            [viewLoaction_ addSubview:imgV];
            
            ix += 20;
            lblLoaction_ = [[UILabel alloc] init];
            [lblLoaction_ setFrame:CGRectMake(ix, 0, 150, 14)];
            [lblLoaction_ setFont:[UIFont systemFontOfSize:CELL_OTHER_CMT_FONT_SIZE]];
            [lblLoaction_ setText:@"深圳市南山区上沙创新园"];
            [lblLoaction_ setTextAlignment:NSTextAlignmentLeft];
            [lblLoaction_ setNumberOfLines:1];
            [lblLoaction_ setLineBreakMode:NSLineBreakByTruncatingTail];
            [lblLoaction_ setBackgroundColor:[UIColor clearColor]];
            [viewLoaction_ addSubview:lblLoaction_];
            
            imgV = [[UIImageView alloc] init];
            [imgV setFrame:CGRectMake(viewLoaction_.frame.size.width - 80, 0, 14, 14)];
            [imgV setImage:[UIImage imageNamed:@"home_read.png"]];
//            [viewLoaction_ addSubview:imgV];
            
            lblLookUpCount_ = [[UILabel alloc] init];
            [lblLookUpCount_  setBackgroundColor:[UIColor clearColor]];
            [lblLookUpCount_ setFrame:CGRectMake(viewLoaction_.frame.size.width - 60, 0, 40, 14)];
            [lblLookUpCount_ setFont:[UIFont systemFontOfSize:CELL_OTHER_CMT_FONT_SIZE]];
            [lblLookUpCount_ setText:@"100"];
//            [viewLoaction_ addSubview:lblLookUpCount_];
        }
//        BBINFO(@"cell height -----%f", fy+CELL_OTHER_CMT_HEiGHT);
//        [imgeViewBg_ setFrame:CGRectMake(CELL_LEFT_SPACE, 0, SCR_WIDTH - CELL_LEFT_SPACE, 330)];
//        [imgeViewBg_ setImage:[[UIImage imageNamed:@"home_cell_bg.png"] stretchableImageWithLeftCapWidth:44 topCapHeight:79]];
//        rct = [self getRect:CELL_LEFT_SPACE withPosY:0.0 withwidth:3.0 withHeight:330];
//        [imgViewTimes_ setFrame:rct];
    }
    return self;
}

- (void)resizeHeight
{
    float fTop = CELL_TOP_SPACE;
    if(_arrayImages.count > 0)
    {
//        BImage *bimage = [_arrayImages objectAtIndex:0];
//        float fHeight = [bimage.height floatValue];
//        float fWidth = [bimage.width floatValue];
//        float fw = 1.0;
//        float fh = 1.0;
//        fw = CELL_CMT_WIDTH;
//        float fscale = fw / fWidth;
//        fh = fHeight * fscale;
//        if(fh >= CELL_IMAGE_MAX_HEIGHT)
//            fh = CELL_IMAGE_MAX_HEIGHT;
//         UIImageView *imgview = [arrayImageView_ objectAtIndex:0];
//        [imgview setFrame:CGRectMake(CELL_LEFT_SPACE + CELL_CMT_LEFT_SPACE, fTop, CELL_CMT_WIDTH, fh)];
//        fTop += fh;
        fTop += CELL_BIG_IMAGE_HEIGHT;
        fTop += CELL_SML_IMAGE_MARGIN;
    }
    if(_arrayImages.count > 1)
    {
//        for (int i = 0; i < 3; i++) {
//            UIImageView *imgview = [arrayImageView_ objectAtIndex:i + 1];
//            CGRect rct = imgview.frame;
//            rct.origin.y = fTop;
//            [imgview setFrame:rct];
//        }
        fTop += CELL_SML_IMAGE_HEIGHT;
        fTop += CELL_SML_IMAGE_MARGIN;
    }
    if(!lblContent_.text || [lblContent_.text isEqual:[NSNull null]] || [lblContent_.text isEqualToString:@""])
    {
        [lblContent_ setHidden:YES];
    }
    else
    {
        CGSize size = [lblContent_.text sizeWithFont:[UIFont systemFontOfSize:CELL_CMT_FONT_SIZE] constrainedToSize:CGSizeMake(CELL_CMT_WIDTH, 100 * fScr_Scale) lineBreakMode:NSLineBreakByTruncatingTail];
        [lblContent_ setFrame:CGRectMake(CELL_LEFT_SPACE + CELL_CMT_LEFT_SPACE, fTop, CELL_CMT_WIDTH, size.height)];
        fTop += size.height;
        fTop += CELL_SML_IMAGE_MARGIN;
    }
    [viewMeia_ setFrame:CGRectMake(CELL_LEFT_SPACE + CELL_CMT_LEFT_SPACE, fTop, CELL_CMT_WIDTH, CELL_OTHER_CMT_HEiGHT)];
    fTop += CELL_OTHER_CMT_HEiGHT;
    fTop += CELL_SML_IMAGE_MARGIN;
    
    [viewLoaction_ setFrame:CGRectMake(CELL_LEFT_SPACE + CELL_CMT_LEFT_SPACE, fTop, CELL_CMT_WIDTH, CELL_OTHER_CMT_HEiGHT)];
    fTop += CELL_OTHER_CMT_HEiGHT;
    fTop += CELL_BTM_SPACE;
    if(fTop < CELL_MIN_HEIGHT)
    {
        fTop = CELL_MIN_HEIGHT;
        float fHeight = fTop - CELL_BTM_SPACE - CELL_OTHER_CMT_HEiGHT;
        [viewLoaction_ setFrame:CGRectMake(CELL_LEFT_SPACE + CELL_CMT_LEFT_SPACE, fHeight, CELL_CMT_WIDTH, CELL_OTHER_CMT_HEiGHT)];
        
        fHeight -= CELL_OTHER_CMT_HEiGHT;
        fHeight -= CELL_SML_IMAGE_MARGIN;
        [viewMeia_ setFrame:CGRectMake(CELL_LEFT_SPACE + CELL_CMT_LEFT_SPACE, fHeight, CELL_CMT_WIDTH, CELL_OTHER_CMT_HEiGHT)];
    }
        
    [imgeViewBg_ setFrame:CGRectMake(CELL_LEFT_SPACE, 0, SCR_WIDTH - CELL_LEFT_SPACE, fTop)];
    [imgeViewBg_ setImage:[[UIImage imageNamed:@"home_cell_bg.png"] stretchableImageWithLeftCapWidth:44 * fScr_Scale topCapHeight:79 * fScr_Scale]];
    CGRect rct = [BBMisc getRect:CELL_LEFT_SPACE withPosY:0.0 withwidth:3.0 withHeight:fTop];
//    if(self.isLast)
//        [imgViewTimes_ setImage:[UIImage imageNamed:@"endOfHistory.png"]];
//    else
//        [imgViewTimes_ setImage:[UIImage imageNamed:@"historyVerticalLine.png"]];
    [imgViewTimes_ setFrame:rct];
    
}

- (void)setBrecord:(BBRecord *)brecord
{
    if(_brecord != brecord)
    {

        _brecord = brecord;
        if(_brecord)
        {
            NSString *strDateTime = [_brecord.create_date  qzgetDateFormat];
            NSArray *array = [strDateTime componentsSeparatedByString:@" "];
            if(array.count == 2)
            {
                lblDate_.text = [NSString stringWithFormat:@"%@", [[array objectAtIndex:0] substringFromIndex:5]];
                lblTime_.text = [NSString stringWithFormat:@"%@", [[array objectAtIndex:1] substringToIndex:5]];
            }
            int iMood = [_brecord.mood integerValue];
            if (iMood <= 16) {
                [lblContent_ setTextColor:[UIColor purpleColor]];
            }
            else
                [lblContent_ setTextColor:[UIColor blackColor]];
            [imgViewMood_ setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%.3i.png", iMood]]];
            int iMoodCount = [_brecord.mood_count integerValue];
            if(iMoodCount <= 0)
                iMoodCount = 1;
            else if(iMoodCount > 3)
                iMoodCount = 3;
            float fW = CELL_MOOD_WH / 2 + CELL_MOOD_WH / 7 * iMoodCount;
            CGRect frame = imgViewMood_.frame;
            CGRect rct = [BBMisc getRect:CELL_LEFT_SPACE withPosY:frame.origin.y withwidth:fW withHeight:fW];
            [imgViewMood_ setFrame:rct];
            lblLoaction_.text  = _brecord.location;
            unsigned int iShareType = [_brecord.shared_type integerValue];
            [viewShare_.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            int ix = 0;
            for (int i = 0; i < 5; i++) {
                if((iShareType >> i) &0x01)
                {
                    int iShare = 14;
                    ix += iShare * i;
                    UIImageView *imgV = [[UIImageView alloc] init];
                    [imgV setImage:[UIImage imageNamed:[arrayShare_ objectAtIndex:i]]];
                    [imgV setFrame:CGRectMake(ix, 0, 12, 12)];
                    [viewShare_ addSubview:imgV];
                }
            }
            lblLookUpCount_.text = [NSString stringWithFormat:@"%@", _brecord.lookup];
        }
    }
}

- (void)setArrayImages:(NSArray *)arrayImages
{
    if(_arrayImages != arrayImages)
    {
        _arrayImages = arrayImages;
        lblImageCount_.text = [NSString stringWithFormat:@"%d", _arrayImages.count];
        NSString *strNotePath = [DataModel getNotePath:_brecord];
        if (!_arrayImages || _arrayImages.count < 1) {
            [_arrayImages sortedArrayUsingFunction:compareImages context:nil];
            for (int i = 0; i < 4; i++) {
                 UIImageView *imgView = [arrayImageView_ objectAtIndex:i];
                [imgView setHidden:YES];
            }
            return;
        }
        for(int i = 0; i < 4; i ++)
        {
            UIImageView *imgView = [arrayImageView_ objectAtIndex:i];
            if( i > _arrayImages.count - 1)
            {
                [imgView setHidden:YES];
                continue;
            }
            [imgView setHidden:NO];
            BImage *bimage = [_arrayImages objectAtIndex:i];
            
            [imgView setImage:nil];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                UIImage *img = [UIImage imageWithContentsOfFile:[strNotePath stringByAppendingPathComponent:bimage.data_path]];
                UIImage *scaleImg = [img clipImageToScaleSize:imgView.bounds.size];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imgView setImage:scaleImg];
                });
            });
        }
    }
}

- (void)setArrayAudios:(NSArray *)arrayAudios
{
    if(_arrayAudios != arrayAudios)
    {
        _arrayAudios  = arrayAudios;
        //[_arrayAudios sortedArrayUsingFunction:compareAudios context:nil];
        lblAudioCount_.text = [NSString stringWithFormat:@"%d", _arrayAudios.count];
    }
}

- (void)setBcontent:(BBText *)bcontent
{
    if(_bcontent != bcontent)
    {
        _bcontent = bcontent;
        lblContent_.text = _bcontent.text;
    }
}

@end


@implementation ImageCell
@synthesize strImage = _strImage;

- (void)dealloc
{
    self.strImage = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImageView *imgViewTimes_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"historyVerticalLine.png"]];
        CGRect rct = [BBMisc getRect:CELL_LEFT_SPACE withPosY:0.0 withwidth:3.0 withHeight:CELL_TITLE_BG_HEIGHT];
        [imgViewTimes_ setFrame:rct];
        [self addSubview:imgViewTimes_];
        
        bgImgView_ = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, CELL_TITLE_BG_MAGRIN, SCR_WIDTH, CELL_TITLE_BG_HEIGHT)];
        CALayer *layer = [bgImgView_ layer];
//        layer.borderColor = [CELLIMAGEBORER_COLOR CGColor];
//        layer.borderWidth = 2.0f;
        layer.shadowColor = CELLIMAGEBORER_COLOR.CGColor;
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowOpacity = 0.8;
        layer.shadowRadius = 2;
        [bgImgView_ setContentMode:UIViewContentModeScaleAspectFill];
        [bgImgView_ setClipsToBounds:YES];
        [self addSubview:bgImgView_];
    }
    return self;
}

- (void)setStrImage:(NSString *)strImage
{
    if(_strImage != strImage)
    {
        _strImage = strImage;
        if(_strImage)
        {
            [bgImgView_ setImage:[UIImage imageWithContentsOfFile:strImage]];
        }
    }
}
@end

@implementation DateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        CGRect rct = [BBMisc getRect:CELL_LEFT_SPACE withPosY:0.0 withwidth:12.0 withHeight:14.0];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rct];
        [imgView setImage:[UIImage imageNamed:@"endOfHistory.png"]];
        [self addSubview:imgView];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CELL_LEFT_SPACE +  12, 0.0, 150, 14)];
        [lable setBackgroundColor:[UIColor clearColor]];
        [lable setFont:[UIFont boldSystemFontOfSize:12]];
        [lable setTextColor:[BBSkin shareSkin].bgTxtColor];
        [lable setText:[BBUserDefault getTheTimeOfFirstUseApp]];
        [self addSubview:lable];
        
    }
    return self;
}

@end

