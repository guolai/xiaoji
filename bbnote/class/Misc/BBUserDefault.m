//
//  UserDefault.m
//  jyy
//
//  Created by bob on 3/15/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BBUserDefault.h"
#import "DataModel.h"
#import "NSDate+String.h"
#import "BImage.h"
#import "FileManagerController.h"


@implementation BBUserDefault
+ (BOOL)isFirstLaunchIn
{
    NSString* strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if(![userDefault objectForKey:@"jyyversion"])
    {
        [self saveFirstTimeUserMyApp];
        strVersion = [NSString stringWithFormat:@"%f", ([strVersion floatValue] + 0.1)];
        [userDefault setObject:strVersion forKey:@"jyyversion"];
        [userDefault synchronize];
        return YES;
    }
    else
    {
        float fSaveVersion = [[userDefault objectForKey:@"jyyversion"] floatValue];
        float fVersion = [strVersion floatValue];
        if(fSaveVersion <= fVersion)
        {
            strVersion = [NSString stringWithFormat:@"%f", (fVersion + 0.1)];
            [userDefault setObject:strVersion forKey:@"jyyversion"];
            [userDefault synchronize];
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)shouldCreateDemo
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([[userDefault objectForKey:@"shouldCreateDemo"] isEqualToString:@"NO"])
        return NO;
    [userDefault setObject:@"NO" forKey:@"shouldCreateDemo"];
    [userDefault synchronize];
    return YES;
}

+(NSString*)getUserId
{
    NSString *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    return number;
}


+(void)setUserId:(NSString *)number
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:number forKey:@"userid"];
    [userDefault synchronize];
}

+ (void)setLastUpdateTimeString:(NSString *)strTime
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:strTime forKey:@"lastupdatetimestring"];
    [userDefault synchronize];
}

+ (NSString *)getLastUpdateTimeString
{
    NSString *strValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastupdatetimestring"];
    return strValue;
}

+ (void)setLastUpdateTime:(NSDate *)date
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:date forKey:@"lastupdatetimestring"];
    [userDefault synchronize];
}

+ (NSDate *)getLastUpdateTime
{
    //NSString *strValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastupdatetimestring"];
    return nil;
}



//数据备份，防止丢失数据
// note
+ (NSDictionary *)getArchiverDataOfNote
{
    NSDictionary *noteDic = nil;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"bbnote"] || [[userDefault objectForKey:@"bbnote"] isKindOfClass:[NSDictionary class]])
    {
        noteDic = [userDefault objectForKey:@"bbnote"];
    }
    return noteDic;
}

+ (void)deleteArchvierDataNote
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bbnote"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setArchvierData:(NSDictionary *)dic
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dic forKey:@"bbnote"];
    [userDefault synchronize];
}




//评价我们
+ (BOOL)showRateUs
{
    BOOL bValue = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showrateus"]) {
        bValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"showrateus"] boolValue];
    }
    return bValue;
}

+ (void)setShowRateUs:(BOOL)value
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithBool:value] forKey:@"showrateus"];
    [userDefault synchronize];
}

+ (void)removeRateUs
{
    NSString* strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    float version = [strVersion floatValue];
    version += 0.01;
    strVersion = [NSString stringWithFormat:@"%f", version];
    [[NSUserDefaults standardUserDefaults] setObject:strVersion forKey:@"system-version"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"usetimes"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"showrateus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//密码保护
+ (BOOL)isOpenedProtect
{
    BOOL bValue = NO;
    if (!ISEMPTY([[NSUserDefaults standardUserDefaults] objectForKey:@"protectpassword"]))
    {
        bValue = YES;
    }
    return bValue;
}

+ (NSString *)getProtectPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"protectpassword"];
}

+ (void)setProtectPasswrod:(NSString *)str
{
    if(!str)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"protectpassword"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"protectpassword"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/*展示首页是否需要动画*/
+ (void)setShouldShowAnimation:(BOOL)bValue
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithBool:bValue] forKey:@"ShouldShowAnimation"];
    [userDefault synchronize];
}
+ (BOOL)isShouldShowAniamtion
{
    BOOL bRet = NO;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    bRet = [[userDefault objectForKey:@"ShouldShowAnimation"] boolValue];
    return bRet;
}

///////时光轴
+ (int)getHomeViewIndex //返回0说明不需要变动，返回小于0，说明要重载，大于0，需要滚动到相应位置
{
    int ret = 0;
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if([userdefault objectForKey:@"index"])
    {
        ret = [[userdefault objectForKey:@"index"] integerValue];
    }
    return ret;
}

+ (void)setHomeViewIndex:(int)iindex
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:iindex] forKey:@"index"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString *)getTimelineTitleImage
{
    NSString *strImg = [[NSUserDefaults standardUserDefaults] objectForKey:@"notephotoname"];
    if(!strImg)
    {
        strImg = @"defaultcover.jpg";
        [self setTimelineTitleImage:strImg];
    }
    return strImg;
}
+ (void)setTimelineTitleImage:(NSString *)strImg
{
    [[NSUserDefaults standardUserDefaults] setObject:strImg forKey:@"notephotoname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)deleteSavedImageFromAblum
{
    
    NSArray *array = [self getSavedAblumImage];
    if(array && array.count > 0)
    {
        for (BImage *bimg  in array) {
            [FileManagerController removeFile:bimg.data_path];
        }
    }
    
}

+ (void)saveImageFormAblum:(NSArray *)array
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if(array.count > 0)
    {
        [userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:array] forKey:@"selectedimage"];
    }
    else
    {
        [userDefault removeObjectForKey:@"selectedimage"];
    }
     [userDefault synchronize];
}

+ (NSArray *)getSavedAblumImage
{
    NSArray *retarray = nil;
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if([userdefault objectForKey:@"selectedimage"])
    {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:[userdefault objectForKey:@"selectedimage"]];
        if(array && array.count > 0)
        {
            retarray = array;
        }
    }
    [self saveImageFormAblum:nil];
    return retarray;
}



//////////////////////////////
+ (void)saveFirstTimeUserMyApp
{
    [[NSUserDefaults standardUserDefaults] setObject:@"2015/03/23" forKey:@"firstin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getTheTimeOfFirstUseApp
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"firstin"];
}
//passwd
+ (void)setPasswdOn:(BOOL)bvalue
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bvalue] forKey:@"passwdon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getPasswdStatus
{
    BOOL bOn = NO;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwdon"];
    if(number && [number integerValue] == 1)
    {
        bOn = YES;
    }
    return bOn;
}
/* weibo*/
+ (void)setQQOn:(BOOL)bvalue
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bvalue] forKey:@"qq"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getQQstatus
{
    BOOL bOn = NO;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"qq"];
    if(number && [number integerValue] == 1)
    {
        bOn = YES;
    }
    return bOn;
}
+ (void)setSinaOn:(BOOL)bvalue
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bvalue] forKey:@"sina"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getSinastatus
{
    BOOL bOn = NO;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"sina"];
    if(number && [number integerValue] == 1)
    {
        bOn = YES;
    }
    return bOn;
}
+ (void)setRenrenOn:(BOOL)bvalue
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bvalue] forKey:@"renren"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getRenrenstatus
{
    BOOL bOn = NO;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"renren"];
    if(number && [number integerValue] == 1)
    {
        bOn = YES;
    }
    return bOn;
}
+ (void)setTcWeiboOn:(BOOL)bvalue
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bvalue] forKey:@"tcweibo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getTcWeibostatus
{
    BOOL bOn = NO;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"tcweibo"];
    if(number && [number integerValue] == 1)
    {
        bOn = YES;
    }
    return bOn;
}

//sound
+ (void)setSoundOn:(BOOL)bvalue
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bvalue] forKey:@"sound"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getSoundstatus
{
    BOOL bOn = NO;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"sound"];
    if(number && [number integerValue] == 1)
    {
        bOn = YES;
    }
    return bOn;
}

/*skin */
+ (void)setSkinValue:(NSNumber *)strValue
{
    [[NSUserDefaults standardUserDefaults] setObject:strValue forKey:@"skin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSNumber *)getSkinValue
{
    NSNumber *number =  [[NSUserDefaults standardUserDefaults] objectForKey:@"skin"];
    return number;
    
}

/* app name version*/
+ (NSString *)getAppName
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString*appName =[infoDict objectForKey:@"CFBundleDisplayName"];
    return appName;
}

+ (NSString *)getAppVersion
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    return versionNum;
}

+ (NSString *)getAPPBuildVersion
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    return versionNum;
}

//私人定制，锁屏，wifi同步
+ (void)setSyncByWifi:(BOOL)bvalue
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bvalue] forKey:@"syncwifi"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getSyncByWifistatus
{
    BOOL bOn = NO;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"syncwifi"];
    if(number && [number integerValue] == 1)
    {
        bOn = YES;
    }
    return bOn;
}

+ (void)setAutoSync:(BOOL)bvalue
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bvalue] forKey:@"AutoSync"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getAutoSyncstatus
{
    BOOL bOn = NO;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"AutoSync"];
    if(number && [number integerValue] == 1)
    {
        bOn = YES;
    }
    return bOn;
}

+ (void)setLockScreenStatus:(BOOL)bvalue
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bvalue] forKey:@"LockScreenStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getLockScreenStatus
{
    BOOL bOn = NO;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"LockScreenStatus"];
    if(number && [number integerValue] == 1)
    {
        bOn = YES;
    }
    return bOn;
}

@end
