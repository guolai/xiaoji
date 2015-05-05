//
//  EditRecordViewController.h
//  bbnote
//
//  Created by Apple on 13-3-31.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BBDateView.h"

#import "BRecord.h"
#import "BContent.h"
#import "FaceScrView.h"
#import "BBViewController.h"
#import "TileView.h"

@class BBRecord;
@interface TextViewController : BBViewController<UIScrollViewDelegate, BBDateViewDelegate,UIActionSheetDelegate,CLLocationManagerDelegate>
{
    NSString *strBackTitle_;
    UIScrollView *scrView_;
    BOOL bSaved_;
    UITextView *txtFld_;
    UILabel *lblLocation_;
    BOOL bFinishRecord_;
//    IFlySpeechRecognizer *_iFlySpeechRecognizer;
    FaceScrView *faceView_;
    CGRect txtFldFrame_;
    BRecord *bRecord_;
    BContent *bContent_;
    BBDateView *dateView_;
}
@property (nonatomic, retain)BRecord *bRecord;
@property (nonatomic, retain)BContent *bContent;
- (void)backButtonPressed:(id)sender;
- (instancetype)initWithNewNote;
- (void)createNewRecord;
- (instancetype)initWithNote:(BBRecord *)bbrecord;
- (BBRecord *)saveNoteData;
- (NSString *)getNotePath;
@end
