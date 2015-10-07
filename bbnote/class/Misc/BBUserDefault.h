//
//  UserDefault.h
//  jyy
//
//  Created by bob on 3/15/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BBUserDefault : NSObject
+ (BOOL)isFirstLaunchIn;
+ (BOOL)shouldCreateDemo;
+(NSString*)getUserId;
+(void)setUserId:(NSString *)number;


+ (void)setLastUpdateTimeString:(NSString *)strTime;
+ (NSString *)getLastUpdateTimeString;

//+ (void)setLastUpdateTime:(NSDate *)date;
+ (NSDate *)getLastUpdateTime;

//数据备份，防止丢失数据
+ (NSDictionary *)getArchiverDataOfNote;
+ (void)deleteArchvierDataNote;
+ (void)setArchvierData:(NSDictionary *)dic;


//评价我们
+ (BOOL)showRateUs;
+ (void)setShowRateUs:(BOOL)value;
+ (void)removeRateUs;

//密码保护
+ (BOOL)isOpenedProtect;
+ (NSString *)getProtectPassword;
+ (void)setProtectPasswrod:(NSString *)str;



/*展示首页是否需要动画*/
+ (void)setShouldShowAnimation:(BOOL)bValue;
+ (BOOL)isShouldShowAniamtion;


///时光轴
+ (int)getHomeViewIndex;
+ (void)setHomeViewIndex:(int)iindex;
+ (NSString *)getTimelineTitleImage;
+ (void)setTimelineTitleImage:(NSString *)strImg;
/* select image from ablum*/
+ (void)deleteSavedImageFromAblum;
//+ (void)deleteSavedImageKey;
+ (void)saveImageFormAblum:(NSArray *)array;
+ (NSArray *)getSavedAblumImage;

/*home view frist time to use the app*/
+ (void)saveFirstTimeUserMyApp;
+ (NSString *)getTheTimeOfFirstUseApp;

/*passwd*/
+ (void)setPasswdOn:(BOOL)bvalue;
+ (BOOL)getPasswdStatus;
/* weibo */
+ (void)setQQOn:(BOOL)bvalue;
+ (BOOL)getQQstatus;
+ (void)setSinaOn:(BOOL)bvalue;
+ (BOOL)getSinastatus;
+ (void)setRenrenOn:(BOOL)bvalue;
+ (BOOL)getRenrenstatus;
+ (void)setTcWeiboOn:(BOOL)bvalue;
+ (BOOL)getTcWeibostatus;

//sound
+ (void)setSoundOn:(BOOL)bvalue;
+ (BOOL)getSoundstatus;

/*skin */
+ (void)setSkinValue:(NSNumber *)strValue;
+ (NSNumber *)getSkinValue;

/* app name version*/
+ (NSString *)getAppName;
+ (NSString *)getAppVersion;
+ (NSString *)getAPPBuildVersion;


//私人定制，锁屏，wifi同步
+ (void)setSyncByWifi:(BOOL)bvalue;
+ (BOOL)getSyncByWifistatus;

+ (void)setAutoSync:(BOOL)bvalue;
+ (BOOL)getAutoSyncstatus;

+ (void)setLockScreenStatus:(BOOL)bvalue;
+ (BOOL)getLockScreenStatus;

@end
