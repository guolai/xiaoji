//
//  KTPhotoScrollViewController.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/4/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBViewController.h"
#import "BBTitleView.h"
//typedef struct
//{
//    int index; //记录数组中的index
//    int iArrayIndex; //图片 浏览中查看到的index
//    int iTotalCout; // 本条记录中所有图片的个数（包括文字那页 ，文字默认为0）
//    int iTotalIndex; //所有图片的数组索引
//    NSString *strUUid; //本条记录的唯一标识ＵＵＩＤ，通过它来修改此条记录
//    NSMutableArray *arrayData;
//    NSDate *date;
//    NSString *strMood;
//    int iMoodCount;
//}Record_S;

@interface ScrRecord : NSObject
@property (nonatomic, assign) int index; //记录数组中的index
@property (nonatomic, assign) int iArrayIndex; //图片 浏览中查看到的index
@property (nonatomic, assign) int iTotalCout; // 本条记录中所有图片的个数（包括文字那页 ，文字iArrayIndex默认为0）
@property (nonatomic, assign) int iTotalIndex; //所有图片的数组索引
@property (nonatomic, retain) NSString *strUUid; //本条记录的唯一标识ＵＵＩＤ，通过它来修改此条记录
@property (nonatomic, retain) NSMutableArray *arrayData;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *strMood;
@property (nonatomic, assign) int iMoodCount;
@end

@class KTPhotoViewController;
@protocol KTPhotoBrowserDataSource;

@interface KTPhotoScrollViewController : BBViewController<UIScrollViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{

    UIScrollView *scrollView_;
    NSInteger photoCount_;
    NSMutableArray *photoViews_;

    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
    int firstVisiblePageIndexBeforeRotation_;
    CGFloat percentScrolledIntoFirstVisiblePage_;


    BOOL _bshouldHideStatusBar;

    BOOL bLocalFile_;

    NSTimer *chromeHideTimer_;


    NSMutableArray *array_;

    ScrRecord *curRecord_;
    ScrRecord *priRecord_;
    ScrRecord *nextRecord_;
    BOOL bWillDisappear_;
    BBTitleView *toolbar_;

    BOOL _didSavePreviousStateOfNavBar;
    // Appearance
    BOOL _previousNavBarHidden;
    BOOL _previousNavToolbarHidden;
    BOOL _previousNavBarTranslucent;
    UIBarStyle _previousNavBarStyle;
    UIStatusBarStyle _previousStatusBarStyle;
    UIColor *_previousNavBarTintColor;
    UIColor *_previousNavBarBarTintColor;
    UIBarButtonItem *_previousViewControllerBackButton;
    UIImage *_previousNavigationBarBackgroundImageDefault;
    UIImage *_previousNavigationBarBackgroundImageLandscapePhone;
    
}

- (id)initWithImageArray:(NSMutableArray *)array andStartWithPhotoAtIndex:(NSUInteger)index andLocalFile:(BOOL)bLocale;
- (void)toggleChromeDisplay;

@end
