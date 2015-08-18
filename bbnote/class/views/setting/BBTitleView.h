//
//  BBTitleView.h
//  bbnote
//
//  Created by zhuhb on 13-5-25.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "BB_BBRecord.h"
typedef enum{
    e_PlayState_Pause,
    e_PlayState_Playing,
    e_PlayState_Max
}T_PlayState;



@interface BBTitleView : UIView
{
    @private
    UIView *viewMood_;
    UILabel *lblOrder_;
    UILabel *lblTimes_;
    UIButton *imgviewPlayState_;
    UIImageView *imgviewLocation_;
    UILabel *lblLocation_;
    UIView *viewShareType_;
    UIImageView *imgviewAudio_;
    UILabel *lblCount_;
    int iTopHeight_;
    int iBtmHeight_;
    int iMargin_;
    int iPlayIndex_;
}
@property (nonatomic, retain) NSArray *mulArray;

- (void)setrecord:(BB_BBRecord *)record;
- (void)setMood:(NSString *)strMood andCount:(int)icout;

- (void)setpageOrder:(NSString *)strOrder;

- (void)setPlayState:(T_PlayState)state;

- (void)setLocation:(NSString *)strLocation;

- (void)setShareType:(unsigned int)type;

- (void)setAudioCount:(int)iCount;

- (void)setPlayTimes:(int)ivalue;
@end


@interface FontTitleView : UIView
{
    NSString *strText_;

}
- (void)reloadFontViews;
@end