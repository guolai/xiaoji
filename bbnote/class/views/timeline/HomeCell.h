//
//  HomeCell.h
//  bbnote
//
//  Created by Apple on 13-4-30.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BB_BBRecord.h"
#import "BB_BBImage.h"
#import "BB_BBAudio.h"
#import "BB_BBContent.h"

@interface HomeCell : UITableViewCell
{
    UIImageView *imgViewTimes_;
    
    UIImageView *imgViewMood_;
    UILabel *lblDate_;
    UILabel *lblTime_;
    
    UIImageView *imgeViewBg_;
    NSMutableArray *arrayImageView_;
    UILabel *lblContent_;
    UILabel *lblAudioCount_;
    UILabel *lblImageCount_;
    UILabel *lblLookUpCount_;
    UILabel *lblLoaction_;
    UIView *viewMeia_;
    UIView *viewLoaction_;
    UIView *viewShare_;
    NSArray *arrayShare_;
    
}

@property (nonatomic, retain)BB_BBRecord *brecord;
@property (nonatomic, retain)NSArray *arrayImages;
@property (nonatomic, retain)NSArray *arrayAudios;
@property (nonatomic, retain)BB_BBText *bcontent;
@property (nonatomic, assign)BOOL isLast;


- (void)resizeHeight;
@end


@interface ImageCell : UITableViewCell
{
    UIImageView *bgImgView_;
}
@property (nonatomic, retain) NSString *strImage;
@end

@interface DateCell : UITableViewCell

@end