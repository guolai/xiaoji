//
//  BBPlayer.h
//  bbnote
//
//  Created by Apple on 13-4-22.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum
{
	AS_INITIALIZED = 0,
	AS_STARTING_FILE_THREAD,
	AS_WAITING_FOR_DATA,
	AS_FLUSHING_EOF,
	AS_WAITING_FOR_QUEUE_TO_START,
	AS_PLAYING,
	AS_BUFFERING,
	AS_STOPPING,
	AS_STOPPED,
	AS_PAUSED
} AudioStreamerState;

@interface BBPlayer : NSObject<AVAudioPlayerDelegate>
{

}
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;



+ (id)ShareInstance;

- (void)setPlayList:(NSArray *)array;

- (BOOL)startPlay;

- (void)next;

- (void)pausePlay;

- (void)resumePlay;

- (void)stopPlay;

- (double)trackPostion;


-(AudioStreamerState)playState;
@end
