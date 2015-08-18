//
//  BBPlayer.m
//  bbnote
//
//  Created by Apple on 13-4-22.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBPlayer.h"
#import "BB_BBAudio.h"

@interface BBPlayer()
{
    int iCurIndex_;
}
@property (nonatomic, retain) NSArray *arryLst;
@end
@implementation BBPlayer
@synthesize audioPlayer;
@synthesize arryLst;

static BBPlayer *bbPlayer;

+ (id)ShareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bbPlayer = [[BBPlayer alloc] init];
    });
    return bbPlayer;
}

- (void)setPlayList:(NSArray *)array
{
    self.arryLst = array;
    iCurIndex_ = 0;
    if(self.audioPlayer)
    {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
}

- (BOOL)startPlay
{
    AVAudioSession *audiosession = [AVAudioSession sharedInstance];
    [audiosession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audiosession setActive:YES error:nil];
    if (!self.arryLst || [self.arryLst isEqual:[NSNull null]] || [self.arryLst count] < 1) {
        return NO;
    }

    if(iCurIndex_ > self.arryLst.count - 1)
        return NO;
    if(self.audioPlayer)
    {
        [self.audioPlayer play];
        self.audioPlayer = nil;
    }
    else
    {
        NSString *strUrl = [self getStrUrl];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strUrl] error:NULL];
        if(!self.audioPlayer)
            return NO;
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
    }
    return YES;
}

- (void)next
{
    iCurIndex_ ++;
    if(iCurIndex_ >= self.arryLst.count)
    {
        iCurIndex_ = 0;
        return;
    }
    if(self.audioPlayer)
    {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    if(!self.audioPlayer)
    {
        NSString *strUrl = [self getStrUrl];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strUrl] error:NULL];
        if(!self.audioPlayer)
            return ;
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
    }
}

- (NSString *)getStrUrl
{
    BB_BBAudio *audio = [self.arryLst objectAtIndex:iCurIndex_];
    return audio.data_path;
}

- (void)pausePlay
{
    if(self.audioPlayer)
        [self.audioPlayer pause];
}

- (void)resumePlay
{
    if(self.audioPlayer)
        [self.audioPlayer play];
}

- (void)stopPlay
{
    if(self.audioPlayer)
    {
        [self.audioPlayer stop];
    }
}

- (double)trackPostion
{
    return 0.0;
}

-(AudioStreamerState)playState
{
    if(!self.audioPlayer)
        return AS_STOPPED;
    if([self.audioPlayer isPlaying])
    {
        return AS_PLAYING;
    }
    else
        return AS_PAUSED;
}

#pragma mark --- avplayer delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self next];
}
@end
