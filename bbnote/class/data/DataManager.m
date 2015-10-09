//
//  DataManager.m
//  jyy
//
//  Created by bob on 3/22/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "DataManager.h"
#import "EvernoteSDK.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BBUserDefault.h"
#import "FileManagerController.h"


@interface DataManager()
@property (nonatomic, strong) NSTimer *alertTimer;

@end

@implementation DataManager
static DataManager *dataManager;
@synthesize alertTimer;
@synthesize strName;
@synthesize iTime;
@synthesize noteSetting = _noteSetting;

+ (id)ShareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[DataManager alloc] init];
    });
    return dataManager;
}
- (id)init
{
    if(self = [super init])
    {
        // Initial development is done on the sandbox service
        // Change this to BootstrapServerBaseURLStringUS to use the production Evernote service
        // Change this to BootstrapServerBaseURLStringCN to use the Yinxiang Biji production service
        // BootstrapServerBaseURLStringSandbox does not support the  Yinxiang Biji service
        NSString *EVERNOTE_HOST = BootstrapServerBaseURLStringSandbox;
        
        // Fill in the consumer key and secret with the values that you received from Evernote
        // To get an API key, visit http://dev.evernote.com/documentation/cloud/
        NSString *CONSUMER_KEY = @"bob-ever";
        NSString *CONSUMER_SECRET = @"c03c235d0f50566a";
        
        [EvernoteSession setSharedSessionHost:EVERNOTE_HOST
                                  consumerKey:CONSUMER_KEY
                               consumerSecret:CONSUMER_SECRET];
    }
    return self;
}




- (void)registerLocalAlert:(int)iValue
{
    [self removeLoaclNotification];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *nt = [[UILocalNotification alloc] init];
    NSDate *date = [NSDate date];
    nt.fireDate = [date dateByAddingTimeInterval:10];
    nt.soundName = UILocalNotificationDefaultSoundName;
    nt.alertAction = @"打开";
    nt.hasAction = YES;
    nt.alertBody = @"无线就诊提醒你，时间到了!";
    nt.repeatInterval = 0;
    nt.applicationIconBadgeNumber = 1;
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:@"无线就诊", @"name", nil];
    nt.userInfo = infoDic;
    [[UIApplication sharedApplication] scheduleLocalNotification:nt];
    
}

- (void)removeLoaclNotification
{
    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if(array.count > 1)
    {
        for (UILocalNotification * localnt in array) {
            NSDictionary *userinfo = [localnt userInfo];
            if([[userinfo objectForKey:@"name"] isEqualToString:@"无线就诊"])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:localnt];
            }
        }
    }
}

- (void)openAlert
{
    if(self.alertTimer)
    {
        [self.alertTimer invalidate];
    }
    self.alertTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
}




- (void)playVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)playSound
{
    CFBundleRef mainBundle;
    mainBundle = CFBundleGetMainBundle ();
    CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle,(CFStringRef)@"sound_time", CFSTR("mp3"),NULL);
    SystemSoundID soundID;
    OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)soundFileURLRef, &soundID);
    CFRelease(soundFileURLRef);
    if (err) {
        BBINFO(@"Error occurred assigning system sound!");
    }
    AudioServicesPlaySystemSound(soundID);
}

- (void)closeALert
{
    if(self.alertTimer)
    {
        [self.alertTimer invalidate];
    }
}

- (void)saveNoteSetting
{
    [NSKeyedArchiver archiveRootObject:_noteSetting toFile:[self noteFilePath]];
}

- (NoteSetting *)noteSetting
{
    if(!_noteSetting)
    {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:[self noteFilePath]];
        if(object)
        {
            _noteSetting = (NoteSetting *)object;
        }
        else
        {
            _noteSetting = [[NoteSetting alloc] init];
            _noteSetting.isUseBgImg = YES;
            _noteSetting.strBgImg = @"photo-detail-bg.jpg";
            _noteSetting.strBgColor = @"rgba(255,255,255,1.0)";
            _noteSetting.strFontName = @"FZQKBYSJW--GB1-0";
            _noteSetting.nFontSize = [NSNumber numberWithFloat:14];
            _noteSetting.strTextColor = @"rgba(0,0,0,1.0)";
            [self saveNoteSetting];
        }
    }
    return _noteSetting;
}

- (NSString *)noteFilePath
{
    NSString *strPath = [FileManagerController documentPath];
    strPath = [strPath stringByAppendingPathComponent:@"noteset.plist"];
    return strPath;
}

@end
