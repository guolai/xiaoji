//
//  BBSkin.h
//  bbnote
//
//  Created by Apple on 13-3-30.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    eSkin_EverNote,
    eSkin_Red,
    eSkin_Pink,
    eSkin_Blue,
    eSkin_Black,
    eSkin_White,
    eSkin_BlueSky,
    eSkin_PinkNote,
    eSkin_GreenLeaf,
    eSkin_Default = eSkin_EverNote,
    eSkin_Max = eSkin_GreenLeaf + 1
}EBBSKIN_TYPE;

@interface BBSkin : NSObject
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, retain) UIColor *titleBgColor;
@property (nonatomic, retain) UIColor *bgColor;
@property (nonatomic, retain) UIColor *bgTxtColor;//内容区，直接在背景上面的文字-主要是指home页的文字颜色
@property (nonatomic, strong) UIColor *bgTxtLightColor;//内容区的浅色颜色
@property (nonatomic, assign) float navbarFontSize;
@property (nonatomic, assign) EBBSKIN_TYPE skinType;
+ (BBSkin *)shareSkin;
- (NSString *)getHomeTileImg;
- (NSString *)getNavBarImg;
- (NSString *)getSkinIconImg;
@end
