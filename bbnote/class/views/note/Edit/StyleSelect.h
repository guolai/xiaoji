//
//  StyleSelect.h
//  Zine
//
//  Created by bob on 9/4/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleScrView.h"

typedef enum{
    e_KBState_A,
    e_KBState_B,
    e_KBState_Max // 当前选择状态被再次选中，也就是要隐藏键盘
}T_KeyBoard_Style_State;

@protocol KeyBoardStateDelegate <NSObject>
- (void)keyboardDidChangeState:(T_KeyBoard_Style_State)state;
- (void)keyboardDidSelectStyle:(NSDictionary *)dic;
- (void)keyboardXunFeiInputDidBegin;
- (void)keyboardXunFeiInputDidStop;
@end

@interface KBSelectView : UIImageView
{
    T_KeyBoard_Style_State _kbStateType;
    UIButton *_btnA;
    UIButton *_btnB;
}
- (void)setFrameNextToView:(UIView *)view;
@property (nonatomic, weak) id<KeyBoardStateDelegate> kbDelegate;
@property (nonatomic, assign) T_KeyBoard_Style_State kbStateType;
//@property (nonatomic, assign) Rect bKBRct;//记录系统键盘
//@property (nonatomic, assign) Rect aKBRct;//记录样式选择
//@property (nonatomic, assign) Rect xunfeiRct;//讯飞输入界面
@end

@interface StyleSelectView : UIView<TextStyleDelegate>
@property (nonatomic, retain) NSMutableArray *arrayStyles;
@property (nonatomic, retain) NSMutableArray *arrayBtms;
@property (nonatomic, weak) id<KeyBoardStateDelegate> styleDelegate;
- (id)initWithFrame:(CGRect)frame;
- (void)setCurrentStyles:(NSDictionary *)dic;
@end


@interface XunFeiAudioInputView : UIView
{
    BOOL _bInputting;
    float _fDecibel;//语音分贝 1.0 ~ 30.0
    UIButton *_btnAudioInput;
    UIImageView *_imgViewBig;
    CGRect _bigRct;
    UIImageView *_imgViewSmall;
    CGRect _smallRct;
    float _fBigScale;//1〜5比较合适
    float _fTempScale;
    float _fSmllScale;
    float _fPriBigScale;
    float _fPriSmllScale;
    
    NSTimer *_circleTimer;
    
    
}
@property (nonatomic, weak) id<KeyBoardStateDelegate> xunfeiDelegate;
- (BOOL)isInputting;
- (void)beginAudioInput;
- (void)endAudioInputWithAnimatio:(BOOL)animation;
- (void)setCurrentDecibel:(float)fDecibel;//语音分贝 0.0 ~ 1.0

@end

@interface StyleBtn : UIButton
@property (nonatomic, retain) NSString *strStyle;
@property (nonatomic, retain) NSString *strHlStyle;
@property (nonatomic, retain) UIImage *hlImg;
@property (nonatomic, retain) UIImage *norImg;
@property (nonatomic, retain) NSString *strKey;
@property (nonatomic, assign) BOOL bPressedDown;
- (NSString *)getStyle;
@end