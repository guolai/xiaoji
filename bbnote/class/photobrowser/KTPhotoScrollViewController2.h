//
//  KTPhotoScrollViewController.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/4/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBViewController.h"

@class KTPhotoViewController;
@protocol KTPhotoBrowserDataSource;


@interface KTPhotoScrollViewController2 : BBViewController<UIScrollViewDelegate, UIActionSheetDelegate>
{

   UIScrollView *scrollView_;
   NSUInteger startWithIndex_;
   NSInteger currentIndex_;
   NSInteger photoCount_;
   
   NSMutableArray *photoViews_;

   // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
   int firstVisiblePageIndexBeforeRotation_;
   CGFloat percentScrolledIntoFirstVisiblePage_;
   
   UIStatusBarStyle statusBarStyle_;

    BOOL _bshouldHideStatusBar;
   BOOL rotationInProgress_;
  
   BOOL viewDidAppearOnce_;
   BOOL navbarWasTranslucent_;
    BOOL bLocalFile_;
   
   NSTimer *chromeHideTimer_;
    NSMutableArray *array_;
    
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
@property (nonatomic, strong) NSString *strTitle;

- (id)initWithImageArray:(NSArray *)array andStartWithPhotoAtIndex:(NSUInteger)index andLocalFile:(BOOL)bLocale;
- (void)toggleChromeDisplay;

@end
