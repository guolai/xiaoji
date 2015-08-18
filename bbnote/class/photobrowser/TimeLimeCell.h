//
//  TimeLimeCell.h
//  Zine
//
//  Created by bob on 9/21/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BB_BBRecord.h"
#import "SmartObject.h"
#define TIMELINE_SELECT_RECT CGRectMake(0, 0, 137, 155)
#define TIMELINE_IMAGE_HEIGHT  103


typedef enum
{
    e_Cell_Brief,
    e_Cell_Guide
}T_Cell_Type;

@protocol BBRiefsTableViewCellDelegate;
@protocol BBRiefViewColumnOperateDelegate;




@interface ActivityCell : UITableViewCell
{
}
@end

@interface BBRiefsCell : UITableViewCell<BBRiefViewColumnOperateDelegate>

@property (nonatomic, retain)NSMutableArray *arrayViews;
@property (nonatomic, weak) id<BBRiefsTableViewCellDelegate> delegate;
@property (nonatomic, assign) T_Cell_Type cellStyle;
- (id)initWithReuseIdentifier:strIndefi;
- (void)setCellSmartObjectsArray:(NSArray *)cellBriefViewsArray;


@end

@class BBCardCell;
@class SmartCardCell;
@protocol BBRiefsTableViewCellDelegate <NSObject>
@optional
- (void)briefsTableViewCell:(BBRiefsCell *)cell  didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column;
- (void)briefsGuideTableViewCell:(BBRiefsCell *)cell  didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column;
- (void)cardTableViewCell:(BBCardCell *)cell  didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column;
- (void)smartcardTableViewCell:(SmartCardCell *)cell  didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column;
@end


@class BBRiefViewColumn;
@protocol BBRiefViewColumnOperateDelegate <NSObject>
- (void)willCopyBBRiefViewColumn:(BBRiefViewColumn*)column;
- (void)willDeleteBBRiefViewColumn:(BBRiefViewColumn*)column;
@end

@interface BBRiefViewColumn : UIView
{
    UIImageView *_imgView;
    UIImageView *_imgViewUploading;
    UIImageView *_imgViewReadCount;
    UILabel *_lblReadCount;
    UILabel *_lblTitle;
    UILabel *_lblDate;
    UILabel *_lblBrief;
    UIImageView *_confictView;
    UIView *_shareView;
    UIImageView *_bgImageView;
    
    
    float _fSpace;
    float _fCmtWidth;
}

//@property (nonatomic, retain) UIColor *cHotColor;
//@property (nonatomic, retain) NSArray *arrayColor;
@property (nonatomic) NSUInteger column;
@property (nonatomic, getter = isTimeSelected) BOOL selected;
@property (nonatomic, weak) id<BBRiefViewColumnOperateDelegate> delegate;
@property (nonatomic, strong)SmartObject *smarbObjet;

@end