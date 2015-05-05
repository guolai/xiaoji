//
//  EditRecordViewController.m
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "MediaViewController.h"
#import <CoreAudio/CoreAudioTypes.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "BBAssetPickerNavigationViewController.h"
#import "BBImage.h"
#import "BBRecord.h"
#import "BBAudio.h"
#import "BBVideo.h"
#import "BBContent.h"
#import "BBMisc.h"
#import "BBUserDefault.h"
#import "FileManagerController.h"
#import "NSDate+String.h"
#import "DataModel.h"
#import "UIImage+SCaleImage.h"

@interface MediaViewController ()<BBPresentViewControlerDelegate, UIImagePickerControllerDelegate>
{
    AudiosAddBtnView *audioAddBtn_;
}
@property (nonatomic, retain) ImagesBtnView *imgsBtnView;
@property (nonatomic, retain)NSString *strSelectedImagePath; // 被选中的图片的路径，方便删除和图片查看.
@property (nonatomic, retain)BAudio *delBAudio;

@property (nonatomic, retain)AVAudioRecorder *audioRecorder;
@property (nonatomic, retain)AVAudioPlayer *audioPlayer;
@property (nonatomic, retain)BAudio *bAudio;//临时音频保存在这里面，录制后成功保存，加入数组，并将其置为nil
@property (nonatomic, retain)NSTimer *updateTimer;
@end

@implementation MediaViewController

@synthesize imgsBtnView;
@synthesize strSelectedImagePath;
@synthesize audioPlayer;
@synthesize audioRecorder;
@synthesize updateTimer;
@synthesize delBAudio;
@synthesize bAudio;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(self.updateTimer)
    {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
}

- (instancetype)initWithNewNote
{
    if (self = [super init]) {
        [self createNewRecord];
        [BBUserDefault deleteArchvierDataNote];
    }
    return self;
}

- (void)createNewRecord
{
    [super createNewRecord];
    NSDictionary *noteDic = [BBUserDefault getArchiverDataOfNote];
    if(noteDic)
    {
        arrayAudio_ = [NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"audio"]];
        if(!arrayAudio_ || ![arrayAudio_ isKindOfClass:[NSMutableArray class]])
        {
            arrayAudio_ = [[NSMutableArray alloc] initWithCapacity:4];
            arrayBtnViewAudio_ = [[NSMutableArray alloc] initWithCapacity:4];
        }
        else
        {
            arrayBtnViewAudio_ = [[NSMutableArray alloc] initWithCapacity:4];
        
        }
        arrayImage_ = [NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"image"]];
        if(!arrayImage_ || ![arrayImage_ isKindOfClass:[NSMutableArray class]])
        {
            arrayImage_ = [[NSMutableArray alloc] initWithCapacity:8];
        }
        arrayVideo_ = [NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"video"]];
        if(!arrayVideo_ || ![arrayVideo_ isKindOfClass:[NSMutableArray class]])
        {
            arrayVideo_ = [[NSMutableArray alloc] initWithCapacity:4];
            arrayBtnViewVideo_ = [[NSMutableArray alloc] initWithCapacity:4];
        }
        else
        {
            assert(false);
        }
        
    }
    else
    {
        arrayAudio_ = [[NSMutableArray alloc] initWithCapacity:4];
        arrayImage_ = [[NSMutableArray alloc] initWithCapacity:8];
        arrayVideo_ = [[NSMutableArray alloc] initWithCapacity:4];
        arrayBtnViewVideo_ = [[NSMutableArray alloc] initWithCapacity:4];
        arrayBtnViewAudio_ = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
}

- (instancetype)initWithNote:(BBRecord *)bbrecord
{
    if(self = [super init])
    {
        arrayAudio_ = [[NSMutableArray alloc] initWithCapacity:4];
        arrayImage_ = [[NSMutableArray alloc] initWithCapacity:8];
        arrayVideo_ = [[NSMutableArray alloc] initWithCapacity:4];
        arrayBtnViewVideo_ = [[NSMutableArray alloc] initWithCapacity:4];
        arrayBtnViewAudio_ = [[NSMutableArray alloc] initWithCapacity:4];
        
        BBText *bbtext = bbrecord.contentInRecord;
        self.bRecord = [[BRecord alloc] initWithBBrecord:bbrecord];
        self.bContent = [[BContent alloc] initWithBBText:bbtext];
        NSArray *array = [bbrecord.imageInRecord allObjects];
        for (BBImage *bbimg in array) {
            if([bbimg.iscontent boolValue] && bbimg.data_path)
            {
                NSString *strPath = [[self getNotePath] stringByAppendingPathComponent:bbimg.data_path];
                [FileManagerController removeFile:strPath];
            }
            else
            {
                BImage *bime = [[BImage alloc] initWithBBImage:bbimg];
                [arrayImage_ addObject:bime];
            }
            [bbimg delete];
        }
        array = [bbrecord.audioInRecord allObjects];
        for (BBAudio *bbaudio in array) {
            BAudio *baudio = [[BAudio alloc] initWithBBAudio:bbaudio];
            [arrayAudio_ addObject:baudio];
            [bbaudio delete];
        }
        
        array = [bbrecord.videoInRecord allObjects];
        for (BBVideo *bbvideo in array) {
            BVideo *bvideo = [[BVideo alloc] initWithBBVideo:bbvideo];
            [arrayVideo_ addObject:bvideo];
            [bbvideo delete];
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //data
    bSaved_ = YES;
    bFinishRecord_ = YES;

    float viewHeight = self.height;
    float fTop = 0;
    if(OS_VERSION < 7.0)
    {
        viewHeight -= self.navBarHeight;
        viewHeight -= 20;
    }
    else
    {
        viewHeight -= self.navBarHeight;
        fTop += self.navBarHeight;
    }
    viewHeight -= 30;
    for (BAudio *baudio in arrayAudio_) {
        AudiosBtnView *audoBtnView = [[AudiosBtnView alloc] initWithBAudio:baudio];
        audoBtnView.delegate = self;
        [arrayBtnViewAudio_ addObject:audoBtnView];
    }
  
    
    self.imgsBtnView = [[ImagesBtnView alloc] initWithFrame:CGRectMake(0, viewHeight , self.width, 200)];
    self.imgsBtnView.strNotePath = [self getNotePath];
    self.imgsBtnView.delegate = self;
    [scrView_ addSubview:self.imgsBtnView];
    for (BImage *bimg in arrayImage_) {
        [self.imgsBtnView addImageObject:bimg];
    }
    
    audioAddBtn_ = [[AudiosAddBtnView alloc] initWithDeletegate:self];
    [scrView_ addSubview:audioAddBtn_];
    
    for (AudiosBtnView *audioBtnView in arrayBtnViewAudio_) {
        [scrView_ addSubview:audioBtnView];
    }
    
    [self adjustView];
    [self showBackButton:nil action:@selector(backBtnPressed)];
    [self showRigthButton:NSLocalizedString(@"Submit", nil) withImage:nil highlightImge:nil andEvent:@selector(submitRecored)];
    [self saveRecordToSandbox];
}

- (void)adjustView
{
    CGRect imgsRct = self.imgsBtnView.frame;
    int iY = imgsRct.origin.y + imgsRct.size.height;
    iY += 4;
    for (AudiosBtnView *audioView in arrayBtnViewAudio_) {
        CGRect rct = audioView.frame;
        rct.origin.y = iY;
        [audioView setFrame:rct];
        iY += rct.size.height;
        iY += 4;
    }
    CGRect addRct = audioAddBtn_.frame;
    addRct.origin.y  = iY;
    [audioAddBtn_ setFrame:addRct];
    iY += addRct.size.height;
    [scrView_ setContentSize:CGSizeMake(self.width, iY + 60)];
}


#pragma mark ---event
- (BBRecord *)saveNoteData
{
    BBRecord *bbRecord = [super saveNoteData];
    for (BAudio *bAud in arrayAudio_)
    {
        BBAudio *bbAudio = [BBAudio BBAudioWithBAudio:bAud];
        bbAudio.record = bbRecord;
    }
    for (BImage *bimg in arrayImage_) {
        BBImage *bbimage = [BBImage BBImageWithBImage:bimg];
        bbimage.record = bbRecord;
    }
    for (BVideo *bvideo in arrayVideo_) {
        BBVideo *bbvideo = [BBVideo BBVideoWithBVideo:bvideo];
        bbvideo.record = bbRecord;
    }
    [bbRecord save];
    return bbRecord;
}

- (void)submitRecored
{
    [BBUserDefault deleteArchvierDataNote];
    [BBUserDefault setHomeViewIndex:-1];
    [self showProgressHUD];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[self saveNoteData] saveToSandBoxPath:[self getNotePath]];
        [self dismissProgressHUD];
        [self.navigationController popViewControllerAnimated:YES];
    });

}

- (void)backBtnPressed
{
    BBLOG();
    [super backButtonPressed:nil];

}
- (void)pauseBtnPressed:(id)sender
{
    [self.audioRecorder pause];
    [self showLeftButton:NSLocalizedString(@"Resume", nil) withImage:nil highlightImge:nil andEvent:@selector(resumeBtnPressed:)];
}

- (void)resumeBtnPressed:(id)sender
{
    AVAudioSession *audiosession = [AVAudioSession sharedInstance];
    [audiosession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audiosession setActive:YES error:nil];
    [self.audioRecorder record];
    [self showLeftButton:NSLocalizedString(@"Pause", nil) withImage:nil highlightImge:nil andEvent:@selector(pauseBtnPressed:)];
}


#pragma mark ---savedatatosandbox
- (void)saveRecordToSandbox
{
    if(bRecord_)
    {
        bContent_.text = txtFld_.text;
        bRecord_.mood_count = [NSNumber numberWithInt:[dateView_ getMoodCount]];
        NSLog(@"%@", bContent_.text);
        NSMutableDictionary *noteDic = [NSMutableDictionary dictionaryWithCapacity:4];
        [noteDic setObject:[NSKeyedArchiver archivedDataWithRootObject:bContent_] forKey:@"content"];
        [noteDic setObject:[NSKeyedArchiver archivedDataWithRootObject:bRecord_] forKey:@"record"];
        if(arrayAudio_.count > 0)
           [noteDic setObject:[NSKeyedArchiver archivedDataWithRootObject:arrayAudio_] forKey:@"audio"];
        if(arrayImage_.count > 0)
            [noteDic setObject:[NSKeyedArchiver archivedDataWithRootObject:arrayImage_] forKey:@"image"];
        if(arrayVideo_.count > 0)
            [noteDic setObject:[NSKeyedArchiver archivedDataWithRootObject:arrayVideo_] forKey:@"video"];
        
        [BBUserDefault setArchvierData:noteDic];
        //BBINFO(@"%@", [userDefault objectForKey:@"note"]);
        BBLOG();
//        BBINFO(@"%@", [BBUserDefault getArchiverDataOfNote]);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Chooose Existing", nil)])
    {
        BBAssetPickerNavigationViewController *pikcerViewController = [[BBAssetPickerNavigationViewController alloc] initWithDelegate:self];
        pikcerViewController.type = BBAssetMulSelectPhoto;
        pikcerViewController.strNotePath = [self getNotePath];
        [self presentViewController:pikcerViewController animated:YES completion:nil];
    }
    else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Take Photo", nil)])
    {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSString *requiredMediaType = (NSString *)kUTTypeImage;
        vc.mediaTypes = [[NSArray alloc] initWithObjects:requiredMediaType, nil];
        //vc.allowsEditing = YES;
        vc.delegate = self;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Delete", nil)])
    {
        [self.imgsBtnView removeImage:self.strSelectedImagePath];
        for (int i = 0; i < arrayImage_.count; i++) {
            BImage *bimg = [arrayImage_ objectAtIndex:i];
            if([bimg.data_path isEqualToString:self.strSelectedImagePath])
            {
                [arrayImage_ removeObject:bimg];
                [DataModel deleteBBimageFromKey:bimg.key];
                break;
            }
        }
    }
    else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Delete Record", nil)])
    {
        if(!self.delBAudio)
            return;
        for (int i = 0; i < arrayAudio_.count; i++) {
            BAudio *baudio = [arrayAudio_ objectAtIndex:i];
            if([self.delBAudio.data_path isEqualToString:baudio.data_path])
            {
                AudiosBtnView *audioView = [arrayBtnViewAudio_ objectAtIndex:i];
                [self removeAudioViewFormCurrentView:audioView];
                [arrayAudio_ removeObject:baudio];
                [DataModel deleteBBAudioFromKey:baudio.key];
                break;
            }
        }
        self.delBAudio = nil;
    }
    else
    {
        
    }
}
#pragma mark image piker
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BBINFO(@"%@", info);
    NSString *mediaType =[info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        BBINFO(@"you select a video");
    }
    else if([mediaType isEqualToString:(NSString *) kUTTypeImage])
    {
        BBLOG();
        [self showProgressHUDWithStr:@"loading..."];
        UIImage *pickeImg =[info objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *exifdic = [info objectForKey:UIImagePickerControllerMediaMetadata];
        dispatch_queue_t quene = dispatch_queue_create("bbnote.takephoto", DISPATCH_QUEUE_CONCURRENT);
        bSaved_ = NO;

        dispatch_async(quene, ^{
            BBLOG();
            if(pickeImg && ![pickeImg isEqual:[NSNull null]])
            {
                NSData *data = [DataModel dataWithOrigiImage:pickeImg exifInfo:exifdic];
                UIImage *smlImg = [pickeImg imageAutoScale];
                BImage *bimg = [BBMisc saveAssetImageToSand:data smlImag:smlImg path:[self getNotePath] isContent:NO];
                dispatch_sync(dispatch_get_main_queue(), ^{
                        if(bimg)
                        {
                            BBLOG();
                            [self.imgsBtnView addImageObject:bimg];
                            [arrayImage_ addObject:bimg];
                        }
                        [self dismissProgressHUD];
                        bSaved_ = YES;
                    });
            }
        });
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- presentViewcontroller callback delegate
- (void)presentViewCtrDidCancel:(UIViewController *)seder
{
    if(!self.view)
    {
    
    }
    if(seder && [seder isKindOfClass:[BBAssetPickerNavigationViewController class]])
    {
        [BBUserDefault deleteSavedImageFromAblum];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)presentViewCtrDidFinish:(UIViewController *)seder
{
    if(!self.view)
    {
        
    }
    if(seder && [seder isKindOfClass:[BBAssetPickerNavigationViewController class]])
    {
        NSArray *arrayselectedimg = [BBUserDefault getSavedAblumImage];
        BBINFO(@"=========== %@", arrayImage_);
        if(arrayselectedimg  && arrayselectedimg.count > 0)
        {
            [self showProgressHUD];
            for (BImage *bimg in arrayselectedimg) {
                [self.imgsBtnView addImageObject:bimg];
                [arrayImage_ addObject:bimg];
            }
            [self dismissProgressHUD];
        }
        BBINFO(@"%@", arrayImage_);

    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)presentViewCtrDidFinishWithObject:(id)object
{
    if(!self.view)
    {
        
    }
    if(object)
    {
        
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma  mark ---ImagesBtnDelegate
- (void)adjustViewFrame
{
    [UIView animateWithDuration:.4 animations:^{
        [self adjustView];
    } completion:^(BOOL finished){
    }];
    
}

- (void)addImageBtnPressed
{
    if(!bSaved_)
    {
        return;
    }
    if(arrayImage_.count >= 8)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"have reached the max picture of 8", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancle", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self  cancelButtonTitle:NSLocalizedString(@"Cancle", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take Photo", nil), NSLocalizedString(@"Chooose Existing", nil), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    BBLOG();
}

- (void)pictureBtnPressed:(id)sender
{
    ImageButton *imgbtn = (ImageButton *)sender;
    self.strSelectedImagePath = imgbtn.bimage.data_path;
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle", nil) destructiveButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles:nil/*, NSLocalizedString(@"Look up", nil)*/, nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma  mark --- AudiosBtnDelegate

#pragma mark --- recording state operation
-(NSDictionary *)audioRecordSetting
{
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithCapacity:4];
    [mulDic setValue:[NSNumber numberWithInteger:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
  //  [mulDic setValue:[NSNumber numberWithInteger:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    [mulDic setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
    [mulDic setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [mulDic setValue:[NSNumber numberWithInteger:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
    return mulDic;
}



- (void)showRecordingState
{
    //self.title=@"正在录音";
    [self.audioRecorder record];
    if(self.updateTimer)
    {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateRecordingTime) userInfo:nil repeats:YES];
 
    [self showLeftButton:NSLocalizedString(@"Pause", nil) withImage:nil highlightImge:nil andEvent:@selector(restoreNoteState)];
    [self showRigthButton:NSLocalizedString(@"Done", nil) withImage:nil highlightImge:nil andEvent:@selector(finishRecording)];
}

- (void)updateRecordingTime
{
    NSString *strTime = [NSString stringWithFormat:@"%@    %@", NSLocalizedString(@"Recoring", nil), [self formatTime:self.audioRecorder.currentTime]];
    [self showTitle:strTime];
}

- (NSString *)formatTime:(int)seconds {
	if(seconds <= 0)
		return @"00:00";
	int h = seconds / 3600;
	int m = (seconds%3600) / 60;
	int s = seconds%60;
	if(h)
		return [NSString stringWithFormat:@"%02i:%02i:%02i", h, m, s];
	else
		return [NSString stringWithFormat:@"%02i:%02i", m, s];
}

- (void)restoreNoteState
{
    if(self.updateTimer)
    {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
    [self.audioRecorder pause];
    [self showLeftButton:NSLocalizedString(@"Resume", nil) withImage:nil highlightImge:nil andEvent:@selector(showRecordingState)];
}

- (void)finishRecording
{
    self.bAudio.times = [NSNumber numberWithInt:self.audioRecorder.currentTime];
    self.bAudio.create_date = [NSDate date];
    [self.audioRecorder stop];
    [self showBackButton:nil action:nil];
    [self showTitle:NSLocalizedString(@"note", nil)];
    [self showRigthButton:NSLocalizedString(@"Submit", nil) withImage:nil highlightImge:nil andEvent:@selector(submitRecored)];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    bFinishRecord_ = YES;
    if(self.updateTimer)
    {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
    if(flag)
    {
 
        [self addAudioViewToCurrentView];
    }
    else
    {
        [FileManagerController removeFile:self.bAudio.data_path];
        self.bAudio = nil;
    }
    self.audioRecorder = nil;
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    assert(false);
}

- (void)addAudioViewToCurrentView
{
    AudiosBtnView *audoBtnView = [[AudiosBtnView alloc] initWithBAudio:self.bAudio];
    audoBtnView.delegate = self;
    [scrView_ addSubview:audoBtnView];
    [arrayAudio_ addObject:audoBtnView.baudio];
    [arrayBtnViewAudio_ addObject:audoBtnView];
    self.bAudio = nil;
    [UIView animateWithDuration:0.2 animations:^{
        [self adjustView];
    }];
}

- (void)removeAudioViewFormCurrentView:(AudiosBtnView *)auiosBtnView
{
    [UIView animateWithDuration:.2 animations:^{
        [auiosBtnView stopAnimating];
        [auiosBtnView removeFromSuperview];
        [self stopAllMedia];
        [FileManagerController removeFile:[auiosBtnView getAudioPath]];
        [arrayAudio_ removeObject:auiosBtnView.baudio];
        [arrayBtnViewAudio_ removeObject:auiosBtnView];
        [self adjustView];
    } completion:^(BOOL finished){

    }];
}

- (void)addAudioBtnPressed
{
    AVAudioSession *audiosession = [AVAudioSession sharedInstance];
    [audiosession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audiosession setActive:YES error:nil];
    if(!bFinishRecord_)
    {
        return;
    }
    if(self.audioRecorder.isRecording)
        return;
    [self stopAllMedia];
    NSError *error = nil;
    if (!self.bAudio) {
        self.bAudio = [[BAudio alloc] init];
    }

    self.bAudio.data_path = [BBMisc getAudioPath];
    BBINFO(@"%@", self.bAudio.data_path);
    NSURL *url = [NSURL fileURLWithPath:self.bAudio.data_path];
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:[self audioRecordSetting] error:&error];
    if(self.audioRecorder)
    {
        bFinishRecord_ = NO;
        self.audioRecorder.delegate = self;
        [self.audioRecorder recordForDuration:3 * 60];
        if(self.updateTimer)
        {
            [self.updateTimer invalidate];
            self.updateTimer = nil;
        }
        [self showRecordingState];
    }
    else
    {
        BBINFO(@"%@", error.description);
        assert(false);
    }
}

- (void)stopAllMedia
{
    if(self.audioPlayer)
    {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    if(self.audioRecorder)
    {
        [self.audioRecorder stop];
        self.audioRecorder = nil;
    }
}

- (void)audioPlayBtnPressed:(id)sender
{
    AVAudioSession *audiosession = [AVAudioSession sharedInstance];
    [audiosession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audiosession setActive:YES error:nil];
    for (AudiosBtnView *audioView in arrayBtnViewAudio_) {
        
        [audioView stopAnimition];
    }
    AudiosBtnView *audioView = (AudiosBtnView *)sender;
    [audioView startAnimition];
    NSString *strUrl = [audioView getAudioPath];
    self.audioPlayer = [[AVAudioPlayer alloc]  initWithContentsOfURL:[NSURL fileURLWithPath:strUrl] error:nil];
    if(self.audioPlayer)
    {
        [self.audioPlayer play];
        self.audioPlayer.delegate = self;
    }
    BBLOG();
}

- (void)deleteAudio:(id)sender
{
    BBLOG();
    AudiosBtnView *audioBtnView = (AudiosBtnView *)sender;
    self.delBAudio = audioBtnView.baudio;
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle", nil) destructiveButtonTitle:NSLocalizedString(@"Delete Record", nil) otherButtonTitles:nil/*, NSLocalizedString(@"Look up", nil)*/, nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.audioPlayer = nil;
    for (AudiosBtnView *audioView in arrayBtnViewAudio_) {
        
        [audioView stopAnimition];
    }
}

- (BOOL)isSupportSwipePop {
    return NO;
}
@end
