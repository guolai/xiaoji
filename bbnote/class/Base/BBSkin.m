//
//  BBSkin.m
//  bbnote
//
//  Created by Apple on 13-3-30.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBSkin.h"
#import "BBUserDefault.h"


@implementation BBSkin
@synthesize titleColor;
@synthesize titleBgColor;
@synthesize bgColor;
@synthesize bgTxtColor;
@synthesize bgTxtLightColor;
@synthesize navbarFontSize;
@synthesize skinType = _skinType;

- (void)dealloc
{
    self.titleBgColor = nil;
    self.titleColor = nil;
    self.bgColor = nil;
    self.bgTxtColor= nil;

}

+ (BBSkin *)shareSkin
{
    static dispatch_once_t once;
    static BBSkin *shareSkin;
    dispatch_once(&once, ^{
        shareSkin =  [[BBSkin alloc] init];
    });
    return shareSkin;
}

- (id)init
{
    if(self = [super init])
    {
        self.skinType = self.skinType;
    }
    return self;
}



- (void)setSkinType:(EBBSKIN_TYPE)skinType
{
    int iValue = skinType;
    if(iValue < 0 || iValue >= eSkin_Max)
    {
        _skinType = eSkin_Default;
    }
    else
    {
        _skinType = skinType;
    }
    [BBUserDefault setSkinValue:[NSNumber numberWithUnsignedInteger:_skinType]];
    switch (_skinType) {
        case eSkin_EverNote:
        {
            self.titleBgColor =  [UIColor colorWithRed:81/255.0 green:140/255.0 blue:87/255.0 alpha:1.0];
            self.bgColor = [UIColor colorWithRed:179/255.0 green:211/255.0 blue:182/255.0 alpha:1.0];
            self.titleColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            self.bgTxtColor = [UIColor colorWithRed:81/255.0 green:140/255.0 blue:87/255.0 alpha:1.0];
            self.bgTxtLightColor = [UIColor colorWithRed:81/255.0 green:140/255.0 blue:87/255.0 alpha:0.7];
            
        }
            break;
        case eSkin_Red:
        {
            self.titleBgColor = [UIColor colorWithRed:242/255.0 green:89/255.0 blue:100/255.0 alpha:1.0];
            self.bgColor = [UIColor colorWithRed:249/255.0 green:145/255.0 blue:154/255.0 alpha:1.0];
            self.titleColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            self.bgTxtColor = [UIColor colorWithRed:242/255.0 green:89/255.0 blue:100/255.0 alpha:1.0];
            self.bgTxtLightColor = [UIColor colorWithRed:242/255.0 green:89/255.0 blue:100/255.0 alpha:0.7];
        }
            break;
        case eSkin_Pink:
        {
            self.titleBgColor = [UIColor colorWithRed:255/255.0 green:143/255.0 blue:170/255.0 alpha:1.0];
            self.bgColor = [UIColor colorWithRed:250/255.0 green:201/255.0 blue:217/255.0 alpha:1.0];
            self.titleColor = [UIColor grayColor];
            self.bgTxtColor = [UIColor colorWithRed:255/255.0 green:143/255.0 blue:170/255.0 alpha:1.0];
            self.bgTxtLightColor = [UIColor colorWithRed:255/255.0 green:143/255.0 blue:170/255.0 alpha:.7];
        }
            break;
        case eSkin_Blue:
        {
            self.titleBgColor =  [UIColor colorWithRed:73/255.0 green:159/255.0 blue:241/255.0 alpha:1.0];
            self.bgColor = [UIColor colorWithRed:215/255.0 green:228/255.0 blue:240/255.0 alpha:1.0];
            self.titleColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            self.bgTxtColor = [UIColor colorWithRed:73/255.0 green:159/255.0 blue:241/255.0 alpha:1.0];
            self.bgTxtLightColor = [UIColor colorWithRed:73/255.0 green:159/255.0 blue:241/255.0 alpha:0.7];
        }
            break;
        case eSkin_Black:
        {
            self.titleBgColor = [UIColor blackColor];
            self.bgColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
            self.titleColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            self.bgTxtColor = [UIColor colorWithRed:81/255.0 green:140/255.0 blue:87/255.0 alpha:1.0];
            self.bgTxtLightColor = [UIColor colorWithRed:81/255.0 green:140/255.0 blue:87/255.0 alpha:0.7];
        }
            break;
        case eSkin_White:
        {
            self.titleBgColor = [UIColor blackColor];
            self.bgColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
            self.titleColor = [UIColor blackColor];
            self.bgTxtColor = [UIColor blackColor];
            self.bgTxtLightColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:0.7];
        }
            break;
        case eSkin_BlueSky:
        {
            self.titleBgColor =  [UIColor colorWithRed:16/255.0 green:96/255.0 blue:176/255.0 alpha:1.0];
            self.bgColor = [UIColor colorWithRed:76/255.0 green:171/255.0 blue:253/255.0 alpha:1.0];
            self.titleColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            self.bgTxtColor = [UIColor blackColor];
            self.bgTxtLightColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:0.7];
        }
            break;
        case eSkin_PinkNote:
        {
            self.titleBgColor = [UIColor colorWithRed:242/255.0 green:89/255.0 blue:100/255.0 alpha:1.0];
            self.bgColor = [UIColor colorWithRed:249/255.0 green:173/255.0 blue:187/255.0 alpha:1.0];
            self.titleColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            self.bgTxtColor = [UIColor colorWithRed:255/255.0 green:143/255.0 blue:170/255.0 alpha:1.0];
            self.bgTxtLightColor = [UIColor colorWithRed:255/255.0 green:143/255.0 blue:170/255.0 alpha:.7];
        }
            break;
        case eSkin_GreenLeaf:
        {
            self.titleBgColor = [UIColor colorWithRed:129/255.0 green:187/255.0 blue:37/255.0 alpha:1.0];
            self.bgColor = [UIColor colorWithRed:200/255.0 green:232/255.0 blue:152/255.0 alpha:1.0];
            self.titleColor = [UIColor blackColor];
            self.bgTxtColor = [UIColor blackColor];
            self.bgTxtLightColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:0.7];
        }
            break;
        default:
        {
            self.titleBgColor =  [UIColor colorWithRed:81/255.0 green:140/255.0 blue:87/255.0 alpha:1.0];
            self.bgColor = [UIColor colorWithRed:179/255.0 green:211/255.0 blue:182/255.0 alpha:1.0];
            self.titleColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            self.bgTxtColor = [UIColor colorWithRed:81/255.0 green:140/255.0 blue:87/255.0 alpha:1.0];
            self.bgTxtLightColor = [UIColor colorWithRed:81/255.0 green:140/255.0 blue:87/255.0 alpha:0.7];
        }
            break;
    }
    
    self.navbarFontSize = 16;
}

- (EBBSKIN_TYPE)skinType
{
   EBBSKIN_TYPE skinType2 = [[BBUserDefault getSkinValue] unsignedIntegerValue];
    return skinType2;
}

- (NSString *)getHomeTileImg
{
    NSString *strRet = nil;
     if(_skinType <= eSkin_White)
     {
         strRet = @"profile_cover_bg";
     }
    else
    {
        strRet = [NSString stringWithFormat:@"profile_cover_bg_%d", _skinType];
    }
    return strRet;
}

- (NSString *)getNavBarImg
{
    return nil;
}
- (NSString *)getSkinIconImg
{
//    eSkin_EverNote,
//    eSkin_Red,
//    eSkin_Pink,
//    eSkin_Blue,
//    eSkin_Black,
//    eSkin_White,
    NSString *strIconImg = [NSString stringWithFormat:@"skin_%d", self.skinType];
    return strIconImg;
}
@end
