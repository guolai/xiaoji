//
//  Constant.h
//  bbnote
//
//  Created by bob on 5/6/15.
//  Copyright (c) 2015 bob. All rights reserved.
//

#ifndef bbnote_Constant_h
#define bbnote_Constant_h

#define OS_VERSION  [[UIDevice currentDevice].systemVersion floatValue]
#define ISEMPTY(x) (!x || [x isEqual:[NSNull null]] || [x isEqualToString:@""])
#define GETNONIL(x) (ISEMPTY(x) ? @"": x)
#define isIphone3Dot5 (([BBMisc screenHeight] == 480) ? YES : NO)
#define isIphone4Dot (([BBMisc screenHeight] == 568) ? YES : NO)
#define isPhone6 (([BBMisc screenHeight] >= 667) ? YES : NO)
#define isIphone4Dot7 (([BBMisc screenHeight] == 667) ? YES : NO)
#define isIphone5Dot5 (([BBMisc screenHeight] == 736) ? YES : NO)
#define fScr_Scale ([BBAutoSize getResizeScale])



#define kBtnSwitchChanged  @"kBtnSwitchChanged"
//sina weibo
#define kSinaAppKey             @"2835958904"
#define kSinaAppSecret          @"39331988fede149cc1120f69f2e9d440"
#define kSinaAppRedirectURI     @"http://1.ejinbu.sinaapp.com"

#define kQQAppId @"100459790"
#define kQQAppKey @"abb29f770c1c7f6bd29f0161af12fb97"
#define kQQAppREdirectURI @""

#define kWeiXinId @"wx10a924543fbe7280"
#define kWeiXinKey @"ec3be4274b9b80747c699f472801a25e"

#define kSinaWeiboGetUserInfo @"kSinaWeiboGetUserInfo"
#define kSinaWeiboLogOut @"kSinaWeiboLogOut"
#define kSinaWeiboLogIn @"kSinaWeiboLogIn"
#define kTencentWeiboLogOut @"kTencentWeiboLogOut"
#define kTencentWeiboLogIn @"kTencentWeiboLogIn"
#define kSinaWeiboSDKAPIDomain   @"https://open.weibo.cn/2/"


#define kShareMsgOK @"kShareMsgOk"
#define kSkinDidChanged @"kSkinDidChanged"

//photo
#define kPHOTO_SELECTED @"isSelected"
#define kPHOTO_STATE_KEY @"state"
#define kPHOTO_SELECTED_COUNT @"selectedCount"
#define PHOTO_COLUMN_COUNT 4
#define PHOTO_TABLEVIEW_INSETS UIEdgeInsetsMake(2, 0, 2, 0);
#define PHOTO_VIEW_PADDING 4
#define ASSET_WIDTH_WITH_PADDING (79.0f  * fScr_Scale)

#define IMAGE_BUTTON_WIDTH (68 * fScr_Scale)
// note
#define NOTE_IMAGE_PATH @"notes/bbnote/"
#define NOTE_MEDIA_PATH @"notes/media/"
#define NOTE_BG_PATH @"notes/bg/"

// kuaipan upload
#define KPAPP_FOLDER @"app_folder"
#define KPUPLOAD_FOLDER @""
#define KP_USER @"kuaipan"



//#define    DEBUG_ENABLE
#ifdef DEBUG_ENABLE
#define BBINFO(fmt, ...)          NSLog(@"[%@:%d]"fmt, \
[[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent], \
__LINE__, \
##__VA_ARGS__)
#define BBDEALLOC() NSLog(@"*******dealloc%@: %@*****", NSStringFromSelector(_cmd), self);
#define BBLOG() NSLog(@"%s, %d",__PRETTY_FUNCTION__, __LINE__)
#else
#define BBINFO(fmt, ...) ((void)0)
#define BBDEALLOC() ((void)0)
#define BBLOG() ((void)0)
#endif

//此appid为您所申请,请勿随意修改
//this APPID for your application,do not arbitrarily modify
#define APPID @"5200c330"
#define ENGINE_URL @"http://dev.voicecloud.cn:1028/index.htm"

//cell
#define CELL_TITLE_BG_HEIGHT ([BBAutoSize screenWidth])
#define CELL_TITLE_BG_MAGRIN (-60.0f)
#define CELL_TITLE_BG_CELL_HEIGHT (320.0f)

#define CELL_MIN_HEIGHT (90.0f * fScr_Scale)
#define CELL_LEFT_SPACE 26.0f //内容与下边的间距
#define CELL_CMT_LEFT_SPACE 42.0f //内容与左边时光轴的间距
#define CELL_CMT_WIDTH ([BBAutoSize screenWidth] - 80) //内容的宽度
#define CELL_TOP_SPACE 12.0f //内容与上面边的间距
#define CELL_BTM_SPACE 10.0f //内容与下边的间距
#define CELL_MOOD_WH 40.0f //心情标的最大大小

#define CELL_BIG_IMAGE_HEIGHT   ([BBAutoSize screenWidth] - 140)// 320 * 240
#define CELL_SML_IMAGE_WIDTH  (isPhone6 ? (80.0f * fScr_Scale) : (76.0f * fScr_Scale))// (230 - 5 * 2) /3
#define CELL_SML_IMAGE_HEIGHT (isPhone6 ? (60.0f * fScr_Scale) : (57.0f * fScr_Scale))// (230 - 5 * 2) /3   result / 66 * 54
#define CELL_SML_IMAGE_MARGIN  6.0f// 图片间距
#define CELL_CMT_FONT_SIZE (13.0f * fScr_Scale)
#define CELL_OTHER_CMT_FONT_SIZE (10.0f * fScr_Scale)
#define CELL_OTHER_CMT_HEiGHT (15.0f * fScr_Scale)
#define CELL_IMAGE_MAX_HEIGHT (400 * fScr_Scale)

#define CELLIMAGEBORER_COLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define CELL_BG_WIDTH ([BBAutoSize screenWidth] - 40)

#define INPUT_FONT_SIZE (20 * fScr_Scale)

#define CELL_TAG 100

//tableview
#define kTableDelegateEndDraging @"kTableDelegateEndDraging"
#define kTableDelegateDidScroll @"kTableDelegateDidScroll"
#define kTableDelegateDidSelect @"kTableDelegateDidSelect"

#define kFontCellDidSelectedAColor @"kFontCellDidSelectedAColor"

//keyborard
#define keyboardHeight 216

//skin
#define NAVI_BAR_FONT_SIZE (14.0f * fScr_Scale)
#define LOGIN_FONT_SIZE (16.0f * fScr_Scale)
#define TITLE_FONT_SIZE (14.0f * fScr_Scale)
#define TITLE_COLOR [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:0.9]
#define TITLE_COLOR_LIGHT [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.7]
#define FONT_COLOR [UIColor colorWithRed:247/255.0 green:150/255.0 blue:39/255.0 alpha:1.0]
#define FONT_COLOR_HL [UIColor colorWithRed:248/255.0 green:151/255.0 blue:38/255.0 alpha:1.0]

#define SCR_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCR_HEIGHT ([[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)
#define SCR_HEIGHT_P ([[UIScreen mainScreen] bounds].size.height)
#define SCR_STATUS_BAR ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define SCR_TOPBAR (self.navigationController.navigationBar.bounds.size.height)
#define PHOTO_SELECT_BTM_HEIGHT (111 * fScr_Scale)
#define PHOTO_SELECT_RECT_H (78 * fScr_Scale)

#define MYAPPID @"627938670"
#define UMENGKEY @"519cbd7f56240b7df005fadf"
#define uMengNewNote @"createnewnote"

#endif
