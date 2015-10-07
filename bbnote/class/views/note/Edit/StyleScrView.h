//
//  StyleScrView.h
//  Zine
//
//  Created by bob on 9/4/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol  TextStyleDelegate <NSObject>
- (void)textStyleScrollDidStop:(NSString *)strValue type:(NSString *)strType;
@end

typedef enum
{
    e_BV_Text,
    e_BV_Size,
    e_BV_Color
}T_BaseView;

@interface StyleImageView : UIView
@property (nonatomic, retain) NSString *strStyle;  //每个 view上的样式名称，向js传递这个参数
@property (nonatomic, assign) float scale;//6 plus 缩放比例
- (void)setFontName:(NSString *)strText localName:(NSString *)strLocal;
- (void)setFontSize:(NSString *)strText;
- (void)setStringColor:(NSString *)strColor;
- (void)setStyleImg:(NSString *)strName;
@end



@interface StyleScrView : UIScrollView<UIScrollViewDelegate>
{
    NSMutableArray *_imgStoreArray;
    BOOL _bSnapping;
    BOOL _bShouldCallDelegate;//当通过外部设置的方法来定位，将不会调用delegate
    float _fW;//item的宽度
    float _fH;//item的高度
    int _iCount;//真实数组的长度
    int  _iVisibleCount;//当前屏幕上可以看到的item的个数
    SystemSoundID _soundID;
    float _fPriOffset;
    T_BaseView _type;
}
@property (nonatomic, weak) id<TextStyleDelegate> textStyleDelegate;
@property (nonatomic, retain) NSString *strStyleType; //样式类别
@property (nonatomic, retain) NSString *strCurStyle;  //当前选中的样式
- (id)initWithFrame:(CGRect)frame array:(NSArray *)array width:(float)fW height:(float)fH type:(T_BaseView)type;
- (void)setCurrentSelectItem:(NSString *)strItem;
- (BOOL)isMoving;
@end
