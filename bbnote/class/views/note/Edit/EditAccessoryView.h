//
//  EditAccessoryView.h
//  Zine
//
//  Created by user1 on 13-8-1.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontImge.h"

typedef enum {
    e_KB_KeyBoard,
    e_KB_Style,
    e_KB_Paper,
    e_KB_Media,
    e_KB_Max
}T_KeyBoard_Btn;


typedef enum{
    e_KBSlct_Keyboard,  //默认为键盘状态
    e_KBSlct_Style,   //样式
    e_KBSlct_Paper,      // 纸张
    e_KBSlct_Media,       //多媒体
    e_KBSlct_Max // 当前选择状态被再次选中，也就是要隐藏键盘
}T_Accessory_Style_State;
@protocol EditAccessoryViewToolbarDelegate <NSObject>

@required

- (void)accessoryToolbarSelected:(UIButton*)sender type:(T_KeyBoard_Btn)type;

@end



@interface KBBtn : UIButton
@property (nonatomic, strong) FontImge *fontImg;
- (void)setBubttonHl:(BOOL)bValue;
@end


@interface EditAccessoryView : UIView {
    NSMutableArray *_mulArray;
    T_Accessory_Style_State _slctState;
    UILabel *_lblPlaceHolder;
}
@property (nonatomic, assign) T_Accessory_Style_State slctState;
@property (nonatomic, weak) id<EditAccessoryViewToolbarDelegate> btndelegate;
- (void)resetKeyBoardBtnstatus;
//- (void)startShowAutoSaveingAnimation;
//- (void)stopShowAutoSaveingAnimation:(float)delayInSeconds;
- (void)setDefaultKeyBoardBtnStauts;
- (void)setFrameNextToView:(UIView *)view;
- (void)setFrameNextToKeyboard:(UIView *)view;
@end
