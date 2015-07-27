//
//  EditRecordViewController.m
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "TextViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
//#import "iflyMSC/IFlySpeechRecognizer.h"
#import "DateViewController.h"
#import "BBMisc.h"
#import "BBContent.h"
#import "FileManagerController.h"
#import "BRecord.h"
#import "BContent.h"
#import "BSKeyboardControls.h"
#import "NSDate+String.h"
#import "NSString+Help.h"
#import "BBUserDefault.h"
#import "BBSkin.h"
#import "FontViewController.h"
#import "BBImage.h"
//#import "ShareViewController.h"
#import "NSDate+String.h"
#import "DataModel.h"
#import "BBNavigationViewController.h"
#import "DataManager.h"
#import "MobClick.h"

@interface TextViewController ()<BSKeyboardControlsDelegate, FaceClickDelegate, BBPresentViewControlerDelegate>
{

}
@property (nonatomic, retain)BSKeyboardControls *keyboardControl;
@property (nonatomic, retain) UIButton *btnLocation;

@property (nonatomic, retain)NSTimer *saveTimer;
@property (nonatomic, retain)UIScrollView *scrView;
@property (nonatomic, retain)BBDateView *dateView;
@property(nonatomic, retain) CLLocationManager *locationManager;// 定位
@property (nonatomic, retain) TileView *bgImgeView;
@end

@implementation TextViewController
@synthesize saveTimer;
@synthesize scrView = scrView_;
@synthesize dateView = dateView_;

@synthesize bRecord = bRecord_;
@synthesize locationManager;
@synthesize bContent = bContent_;
@synthesize keyboardControl;
@synthesize bgImgeView;


- (instancetype)initWithNewNote
{
    if(self = [super init])
    {
        [self createNewRecord];
        [BBUserDefault deleteArchvierDataNote];
    }
    return self;
}

- (void)createNewRecord
{
    NSDictionary *noteDic = [BBUserDefault getArchiverDataOfNote];
    if(noteDic)
    {
        self.bRecord =[NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"record"]];
        if(!self.bRecord)
        {
            self.bRecord = [[BRecord alloc]init];
        }
        self.bContent = [NSKeyedUnarchiver unarchiveObjectWithData:[noteDic objectForKey:@"content"]];
        if(!self.bContent)
        {
            self.bContent = [[BContent alloc] init];
        }
    }
    else
    {
        self.bRecord = [[BRecord alloc] init];
        self.bContent = [[BContent alloc] init];
    }
    NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
    if(noteset.isUseBgImg)
    {
        self.bRecord.bg_image = noteset.strBgImg;
        self.bRecord.bg_color = noteset.strBgColor;
    }
    else
    {
        self.bRecord.bg_image = nil;
        self.bRecord.bg_color = noteset.strBgColor;
    }
    self.bContent.text_color = noteset.strTextColor;
    self.bContent.fontsize = noteset.nFontSize;
    self.bContent.font = noteset.strFontName;
}

- (instancetype)initWithNote:(BBRecord *)bbrecord
{
    if(self = [super init])
    {
        BBText *bbtext = bbrecord.contentInRecord;
        self.bRecord = [[BRecord alloc] initWithBBrecord:bbrecord];
        self.bContent = [[BContent alloc] initWithBBText:bbtext];
        [bbtext delete];
        NSArray *array = [bbrecord.imageInRecord allObjects];
        for (BBImage *bbimg in array) {
            if([bbimg.iscontent boolValue] && bbimg.data_path)
            {
                NSString *strPath = [[self getNotePath] stringByAppendingPathComponent:bbimg.data_path];
                [FileManagerController removeFile:strPath];
                [bbimg delete];
            }
        }
        NoteSetting *noteset = [[DataManager ShareInstance] noteSetting];
        noteset.strFontName = self.bContent.font;
        noteset.nFontSize = self.bContent.fontsize;
        noteset.strTextColor = self.bContent.text_color;
        if(self.bRecord.bg_image)
        {
            noteset.isUseBgImg = YES;
            noteset.strBgImg = self.bRecord.bg_image;
        }
        noteset.strBgColor = self.bRecord.bg_color;
        [self saveRecordToSandbox];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
    NoteSetting *notest = [[DataManager ShareInstance] noteSetting];

    if(notest.isUseBgImg && notest.strBgImg)
    {
        self.bRecord.bg_image = notest.strBgImg;
        self.bRecord.bg_color = notest.strBgColor;
    }
    else
    {
        self.bRecord.bg_image = nil;
        self.bRecord.bg_color = notest.strBgColor;
    }
    self.bContent.text_color = notest.strTextColor;
    self.bContent.fontsize = notest.nFontSize;

    self.bContent.font = notest.strFontName;
    
    
    
    [self.dateView setDate:self.bRecord.create_date withColor:self.bRecord.title_color andMood:self.bRecord.mood];
    
    if(self.bRecord.bg_image)
    {
        UIImage *img = [UIImage imageNamed:self.bRecord.bg_image];
        [self.bgImgeView  setTileImage:img];
    }
    else
    {
        [self.bgImgeView  setBackgroundColor:[self.bRecord.bg_color getColorFromString]];
    }
    
    if(self.bContent)
    {

        txtFld_.textColor = [self.bContent.text_color getColorFromString];
        
        if(!ISEMPTY(self.bContent.font) && ![self.bContent.font isEqualToString:@"system"] && self.bContent.fontsize && [self.bContent.fontsize integerValue] > 0)
        {
            [txtFld_ setFont:[UIFont fontWithName:self.bContent.font size:[self.bContent.fontsize integerValue]]];
        }
        else 
        {
             [txtFld_ setFont:[UIFont systemFontOfSize:[self.bContent.fontsize integerValue]]];
        }
        txtFld_.text = self.bContent.text;
    }
    self.saveTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(saveRecordToSandbox) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if(self.saveTimer)
    {
        [self.saveTimer invalidate];
        self.saveTimer = nil;
    }
}

- (void)loadView
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    
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
    //view
    
    self.bgImgeView = [[TileView alloc] initWithFrame:CGRectMake(0, fTop, self.width, viewHeight)];
    [self.view addSubview:self.bgImgeView ];
    
    //    imgView set
    self.scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, fTop, self.width, viewHeight)];
    [self.scrView setContentSize:CGSizeMake(self.width, self.height)];
    [self.scrView setContentOffset:CGPointMake(0, 0)];
    [self.scrView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.scrView];
    
    fTop = 0;
    self.dateView = [[BBDateView alloc] initWithFrame:CGRectMake(0, fTop, self.width, 44)];
    self.dateView.delegate = self;
    [self.scrView addSubview:self.dateView];

    fTop += 44;
    
    txtFldFrame_ = CGRectMake(4, fTop, self.width - 8, viewHeight - 110);
    txtFld_ = [[UITextView alloc] initWithFrame:txtFldFrame_];
    [txtFld_ setBackgroundColor:[UIColor clearColor]];

//    CALayer *layer = [txtFld_ layer];
//    layer.cornerRadius = 6.0f;
//    layer.masksToBounds = YES;
//    layer.borderColor = [UIColor blueColor].CGColor;
//    layer.borderWidth = 2.0f;
    txtFld_.multipleTouchEnabled = YES;
    if(self.bContent)
    {
        txtFld_.text = self.bContent.text;
    }
    [self.scrView addSubview:txtFld_];
    self.keyboardControl = [[BSKeyboardControls alloc] initWithFields:@[txtFld_]];
    self.keyboardControl.delegate = self;
    
    float fHelpHeight = 60;
    UIButton *btnLoca = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.bRecord.location)
    {
        [btnLoca setImage:[UIImage imageNamed:@"location_ok.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnLoca setImage:[UIImage imageNamed:@"location_unknow.png"] forState:UIControlStateNormal];
    }
    [btnLoca setImage:[UIImage imageNamed:@"location_unknow.png"] forState:UIControlStateNormal];
    [btnLoca addTarget:self action:@selector(btnLocationPreesed:) forControlEvents:UIControlEventTouchUpInside];
    [btnLoca setFrame:CGRectMake(30, viewHeight - fHelpHeight, 25, 25)];
    [self.scrView addSubview:btnLoca];
    self.btnLocation = btnLoca;
    
    lblLocation_ = [[UILabel alloc] initWithFrame:CGRectMake(70, viewHeight - fHelpHeight, 130, 25)];
    [lblLocation_ setFont:[UIFont systemFontOfSize:10]];
    [lblLocation_ setText:self.bRecord.location];
    [lblLocation_ setBackgroundColor:[UIColor clearColor]];
    [self.scrView addSubview:lblLocation_];
    
    UIButton *btnKeDaXunFei = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnKeDaXunFei setImage:[UIImage imageNamed:@"xunfei.png"] forState:UIControlStateNormal];
    [btnKeDaXunFei addTarget:self action:@selector(btnKeDaXunFeiPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnKeDaXunFei setFrame:CGRectMake(230, viewHeight - fHelpHeight, 25, 25)];
    [self.scrView addSubview:btnKeDaXunFei];
    
    
    UIButton *btnSkin = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString *strFile = [[BBSkin shareSkin] getSkinIconImg];
    BBINFO(@"%@, %@", strFile, [UIImage imageNamed:strFile]);
    [btnSkin setImage:[UIImage imageNamed:strFile] forState:UIControlStateNormal];
    [btnSkin addTarget:self action:@selector(changeTextStyle:) forControlEvents:UIControlEventTouchUpInside];
    [btnSkin setFrame:CGRectMake(270, viewHeight - fHelpHeight, 30, 30)];
    CALayer *layer2 = [btnSkin layer];
    layer2.cornerRadius = 6.0f;
    layer2.masksToBounds = YES;
    layer2.borderColor = [BBSkin shareSkin].titleBgColor.CGColor;
    layer2.borderWidth = 2.0f;
    [self.scrView addSubview:btnSkin];
    { //科大讯飞语音识别
        //初始化语音识别控件
//        NSString *initString = [NSString stringWithFormat:@"appid=%@",APPID];
//        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center initParam:initString];
//        _iflyRecognizerView.delegate = self;
//        
//        [_iflyRecognizerView setParameter:@"domain" value:@"iat"];
//        [_iflyRecognizerView setParameter:@"sample_rate" value:@"16000"];
//        [_iflyRecognizerView setParameter:@"plain_result" value:@"0"];
//        [_iflyRecognizerView setParameter:@"vad_bos" value:@"5000"];
//        [_iflyRecognizerView setParameter:@"vad_eos" value:@"5000"];
////        [_iflyRecognizerView setParameter:@"asr_audio_path" value:@"asrview.pcm"];
//        [_iflyRecognizerView setParameter:@"asr_audio_path" value:nil];  // 当你再不需要保存音频时，请在必要的地方加上这行。
//        
//        
        //        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", IFlySpeechAPPID];
        //        _iFlySpeechRecognizer = [IFlySpeechRecognizer createRecognizer:initString delegate:self];
        //        _iFlySpeechRecognizer.delegate = self;
        //        [_iFlySpeechRecognizer setParameter:@"domain" value:@"iat"];
        //        [_iFlySpeechRecognizer setParameter:@"sample_rate" value:@"16000"];
        //        [_iFlySpeechRecognizer setParameter:@"plain_result" value:@"0"];
        //        [_iFlySpeechRecognizer setParameter:@"vad_bos" value:@"5000"];
        //        [_iFlySpeechRecognizer setParameter:@"vad_eos" value:@"5000"];
//        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID,@"20000"];
//        _iFlySpeechRecognizer = [IFlySpeechRecognizer createRecognizer:initString delegate:self];
//        _iFlySpeechRecognizer.delegate = self;//请不要删除这句,createRecognizer是单例方法，需要重新设置代理
//        [_iFlySpeechRecognizer setParameter:@"domain" value:@"iat"];
//        [_iFlySpeechRecognizer setParameter:@"sample_rate" value:@"16000"];
//        [_iFlySpeechRecognizer setParameter:@"plain_result" value:@"0"];
//        [_iFlySpeechRecognizer setParameter:@"vad_bos" value:@"5000"];
//        [_iFlySpeechRecognizer setParameter:@"vad_eos" value:@"5000"];
        //        [_iFlySpeechRecognizer setParameter:@"asr_audio_path" value:@"asr.pcm"];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    bSaved_ = YES;
    bFinishRecord_ = YES;
    [self showBackButton:nil action:nil];
    [self showRigthButton:NSLocalizedString(@"Submit", nil) withImage:nil highlightImge:nil andEvent:@selector(submitRecored)];
    [self getNotePath];
    [self saveRecordToSandbox];
}


#pragma mark ---event
- (void)tapBackground
{
    BBLOG();
    [txtFld_ resignFirstResponder];
 
}
- (BBRecord *)saveNoteData
{
    [MobClick event:uMengNewNote];
    self.bContent.text = txtFld_.text;
    if(ISEMPTY(self.bContent.text))
    {
        self.bContent.text = @"......Nothing to say...";
    }
    self.bRecord.mood_count = [NSNumber numberWithInt:[self.dateView getMoodCount]];
    BBRecord *bbRecord = [BBRecord initWithBRecord:self.bRecord];
    
    BBText *bbContent = [BBText BBContentWithBContent:self.bContent];
    bbContent.record = bbRecord;
    
    UIImage *img = [BBMisc createImageForBigWeibo:bbRecord];
    NSData *data = UIImageJPEGRepresentation(img, 0.8);
    BImage *bimg = [BBMisc saveAssetImageToSand:data smlImag:nil path:[self getNotePath] isContent:YES];
    BBImage *bbimage = [BBImage BBImageWithBImage:bimg];
//    if([bbimage isKindOfClass:[BBImage class]])
//    {
//        BBLOG();
//    }
//    if([bbimage isMemberOfClass:[BBImage class]])
//    {
//        BBLOG();
//    }
    bbimage.record = bbRecord;
    [bbimage save];
    [bbRecord save];
    return bbRecord;
}

- (void)submitRecored
{
    BBLOG();
    [self.saveTimer invalidate];
    [BBUserDefault setHomeViewIndex:-1];
    [self showProgressHUD];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[self saveNoteData] saveToSandBoxPath:[self getNotePath]];
        [BBUserDefault deleteArchvierDataNote];
        [self dismissProgressHUD];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)backButtonPressed:(id)sender
{
    BBLOG();
    [self.saveTimer invalidate];
    [self saveRecordToSandbox];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnLocationPreesed:(id)sender
{
    [txtFld_ resignFirstResponder];
    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location isn't Available" , nil) message:NSLocalizedString(@"Suggest openning the location(Setting>Location>open bbnote)", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"I See", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //self.locationManager.distanceFilter = 10;
    self.locationManager.purpose = NSLocalizedString(@"Please allow open the service of location", nil);
    [self.locationManager startUpdatingLocation];
}

- (void)btnKeDaXunFeiPressed:(id)sender
{
    [txtFld_ resignFirstResponder];
//     [_iflyRecognizerView start];
}

- (void)changeTextStyle:(id)sender
{
    FontViewController *vc = [[FontViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    BBLOG();
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [txtFld_ resignFirstResponder];
}


#pragma mark ---savedatatosandbox
- (void)saveRecordToSandbox
{
    if(self.bRecord)
    {
        self.bContent.text = txtFld_.text;
        self.bRecord.mood_count = [NSNumber numberWithInt:[self.dateView getMoodCount]];
        NSLog(@"%@", self.bContent.text);
        NSMutableDictionary *noteDic = [NSMutableDictionary dictionaryWithCapacity:4];
        [noteDic setObject:[NSKeyedArchiver archivedDataWithRootObject:self.bContent] forKey:@"content"];
        [noteDic setObject:[NSKeyedArchiver archivedDataWithRootObject:self.bRecord] forKey:@"record"];
     
        [BBUserDefault setArchvierData:noteDic];
        BBLOG();
//        BBINFO(@"%@", [BBUserDefault getArchiverDataOfNote]);
    }
}



#pragma  mark ---BBDateViewDelegate
- (void)changeDateTime
{
    [txtFld_ resignFirstResponder];
    DateViewController *vc = [[DateViewController alloc] init];
    vc.date = self.bRecord.create_date;
    vc.delegate = self;
    BBNavigationViewController *nav = [[BBNavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)changeMood
{
    [txtFld_ resignFirstResponder];
    if(!faceView_)
    {
        faceView_ = [[FaceScrView alloc] initWithDelegate:self];
        faceView_.isHiden = YES;
        [faceView_ setFrame:CGRectMake(0.0f, SCR_HEIGHT_P, SCR_WIDTH, keyboardHeight)];
        [self.view addSubview:faceView_];
    }
    [UIView animateWithDuration:0.2 animations:^{
       
        if(faceView_.isHiden)
        {
            faceView_.isHiden = NO;
            [faceView_ setFrame:CGRectMake(0.0f, self.bgImgeView.frame.origin.y + self.bgImgeView.bounds.size.height - keyboardHeight, SCR_WIDTH, keyboardHeight)];
        }
        else
        {
            faceView_.isHiden = YES;
            [faceView_ setFrame:CGRectMake(0.0f, SCR_HEIGHT_P, SCR_WIDTH, keyboardHeight)];
        }
    }];

}

#pragma mark ---faceviewdelegate btn click
-(void)faceclickAtIndex:(unsigned int)index
{
    self.bRecord.mood = [NSNumber numberWithInt:index];
    [self.dateView changeMood:[NSNumber numberWithInt:index]];
    [UIView animateWithDuration:0.1f animations:^{
        faceView_.isHiden = YES;
        [faceView_ setFrame:CGRectMake(0.0f, SCR_HEIGHT_P, SCR_WIDTH, keyboardHeight)];
    }];
}





#pragma mark --- map event
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        [self.locationManager stopUpdatingLocation];
        [self showProgressHUDWithDetail:NSLocalizedString(@"Error appeared when locating\nPlease check the status of network", nil) hideafterDelay:2.0f];
        return;
    }
    BBLOG();
    [self.locationManager stopUpdatingLocation];
    [self showProgressHUDWithDetail:NSLocalizedString(@"Error appeared when locating\nPlease check the status of network", nil) hideafterDelay:2.0f];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSDate *date = newLocation.timestamp;
    BBINFO(@"%@", newLocation.description);
    NSTimeInterval timerInterval = [date timeIntervalSinceNow];
    if(abs(timerInterval) < 5.0)
    {
        [self.locationManager stopUpdatingLocation];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error){
                 NSLog(@"Geocode failed with error: %@", error);
                 return;
             }
             BBINFO(@"Received placemarks: %@", placemarks);
             [self displayPlacemarks:placemarks];
         }];
    }
    [self dismissProgressHUD];
    
}

- (void)displayPlacemarks:(NSArray *)placemarks
{
    dispatch_async(dispatch_get_main_queue(),^ {
        if ([placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            //BBINFO(@"1%@", placemark.addressDictionary);
            NSDictionary *dic = placemark.addressDictionary;
//            BBINFO(@"1=====%@", [dic objectForKey:@"City"]);
//            BBINFO(@"2=====%@", [dic objectForKey:@"Country"]);
//            BBINFO(@"3=====%@", [dic objectForKey:@"CountryCode"]);
//            BBINFO(@"4=====%@", [dic objectForKey:@"FormattedAddressLines"]);
//            BBINFO(@"5=====%@", [dic objectForKey:@"Name"]);
//            BBINFO(@"6=====%@", [dic objectForKey:@"State"]);
//            BBINFO(@"7=====%@", [dic objectForKey:@"SubLocality"]);
//            BBINFO(@"8=====%@", [dic objectForKey:@"SubThoroughfare"]);
//            BBINFO(@"9=====%@", [dic objectForKey:@"Thoroughfare"]);
//
//
//            BBINFO(@"2%@", placemark.name);
//            BBINFO(@"3%@", placemark.thoroughfare);
//            BBINFO(@"4%@", placemark.subThoroughfare);
//            BBINFO(@"5%@", placemark.locality);
//            BBINFO(@"6%@", placemark.administrativeArea);
//            BBINFO(@"7%@", placemark.subAdministrativeArea);
//            BBINFO(@"8%@", placemark.postalCode);
//            BBINFO(@"9%@", placemark.ISOcountryCode);
//            BBINFO(@"10%@", placemark.country);
//            BBINFO(@"11%@", placemark.inlandWater);
//            BBINFO(@"12%@", placemark.ocean);
//            BBINFO(@"13%@", placemark.areasOfInterest);
            
            
            //BBINFO(@"######################");
            NSString *strCity = [dic objectForKey:@"City"];
            NSString *strDistrict = [dic objectForKey:@"SubLocality"];
            NSString *strRoad = [dic objectForKey:@"Thoroughfare"];
            self.bRecord.location = [NSString stringWithFormat:@"%@%@%@", strCity, strDistrict, strRoad];
            lblLocation_.text = self.bRecord.location;
            [self.btnLocation setImage:[UIImage imageNamed:@"location_ok.png"] forState:UIControlStateNormal];
        }
        
    });
}

#pragma mark keda xunfei callback



#pragma mark delegate
//- (void)onResult:(IFlyRecognizerView *)iFlyRecognizerView theResult:(NSArray *)resultArray
//{
//    NSMutableString *result = [[NSMutableString alloc] init];
//    NSDictionary *dic = [resultArray objectAtIndex:0];
//    for (NSString *key in dic) {
//        [result appendFormat:@"%@",key];
//    }
//    [self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:
//	 result waitUntilDone:YES];
//}
//
//- (void)onEnd:(IFlyRecognizerView *)iFlyRecognizerView theError:(IFlySpeechError *)error
//{
//    AudioSessionSetActiveWithFlags(FALSE, kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation);
////    [self showProgressHUDWithDetail:[NSString stringWithFormat:@"识别结束,错误码:%d",[error errorCode]] hideafterDelay:2.0];
//}
//
//
//
////  set the textView
////  设置textview中的文字，既返回的识别结果
//- (void)onUpdateTextView:(NSString *)sentence
//{	
//	NSString *str = [[NSString alloc] initWithFormat:@"%@%@", txtFld_.text, sentence];
//	txtFld_.text = str;
//}


#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)nt
{
    BBLOG();
    NSNumber *duration = [nt.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [nt.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    /* Move the toolbar to above the keyboard */
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    CGRect frame = txtFldFrame_;
    if(frame.size.height - 216 < 100)
    {
         frame.size.height = 100;
    }
    else
    {
         frame.size.height = frame.size.height - 216;
    }
   
	txtFld_.frame = frame;
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)nt
{
    BBLOG();
    
    NSNumber *duration = [nt.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [nt.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	txtFld_.frame = txtFldFrame_;
	[UIView commitAnimations];

    
}

- (NSString *)getNotePath
{
    return [DataModel getNotePath:self.bRecord];
}

- (BOOL)isSupportSwipePop {
    return NO;
}

- (void)presentViewCtrDidCancel:(UIViewController *)seder
{
    if(!self.view)
    {
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)presentViewCtrDidFinish:(UIViewController *)seder
{
    if(self.view)
    {
        
    }
    if([seder isKindOfClass:[DateViewController class]])
    {
        DateViewController *vc = (DateViewController *)seder;
        self.bRecord.create_date = vc.date;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
