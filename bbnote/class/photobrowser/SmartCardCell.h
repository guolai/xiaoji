//
//  CardCell.h
//  Zine
//
//  Created by bob on 12/18/13.
//  Copyright (c) 2013 aura marker stdio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLimeCell.h"
#import "SmartObject.h"
#import "TimeLimeCell.h"
#define CARD_CELL_RECT CGRectMake(0, 0, 320 * fScr_Scale, 280 * fScr_Scale)

@interface SmartCardCell : UITableViewCell

@property (nonatomic, retain)NSMutableArray *arrayViews;
@property (nonatomic, weak) id<BBRiefsTableViewCellDelegate> delegate;
@property (nonatomic, assign) int iAssetsPerRow;
- (id)initWithReuseIdentifier:strIndefi withColumn:(int)iColumn;
- (void)setCellCardViewsArray:(NSArray *)cellBriefViewsArray;


@end



@interface BBCardViewColumn : UIView
{
    UIImageView *_imgView;
    UIImageView *_imgViewUploading;
    
    float _fSpace;
    float _fCmtWidth;
}

@property (nonatomic) NSUInteger column;
@property (nonatomic, getter = isCardSelected) BOOL selected;
@property (nonatomic, strong)SmartObject *smartObject;
@property (nonatomic, strong)NSString *strLoadingPath;
@end
