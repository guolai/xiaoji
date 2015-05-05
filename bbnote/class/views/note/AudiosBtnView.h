//
//  AudiosBtnView.h
//  bbnote
//
//  Created by Apple on 13-4-9.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAudio.h"

@protocol AudiosBtnDelegate;
@interface AudiosBtnView : UIImageView
{
@private
    int iAudioWidth_;
    int iPlayMixW_;
    int iSapce_;
    int iMaxWidth_;
    int iHeight_;
    UIImageView *animiteImgView_;
    UIButton *btnPlay_;
}

@property (nonatomic, assign) id<AudiosBtnDelegate> delegate;
@property (nonatomic, retain) BAudio *baudio;
- (id)initWithBAudio:(BAudio *)baudio;
- (void)startAnimition;
- (void)stopAnimition;
- (NSString *)getAudioPath;
@end
@interface AudiosAddBtnView : UIImageView
{
@private
    int iHeight_;
}

@property (nonatomic, assign) id<AudiosBtnDelegate> delegate;
- (id)initWithDeletegate:(id<AudiosBtnDelegate>)dlgate;
@end

@protocol AudiosBtnDelegate<NSObject>
- (void)addAudioBtnPressed;
- (void)audioPlayBtnPressed:(id)sender;
- (void)deleteAudio:(id)sender;
@end