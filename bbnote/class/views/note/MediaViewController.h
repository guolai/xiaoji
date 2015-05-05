//
//  EditRecordViewController.h
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AudiosBtnView.h"
#import "ImagesBtnView.h"
#import "TextViewController.h"


@interface MediaViewController : TextViewController<ImagesBtnDelegate, AudiosBtnDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate>
{
    NSMutableArray *arrayImage_;
    NSMutableArray *arrayAudio_;
    NSMutableArray *arrayBtnViewAudio_;
    NSMutableArray *arrayVideo_;
    NSMutableArray *arrayBtnViewVideo_;
}

@end
