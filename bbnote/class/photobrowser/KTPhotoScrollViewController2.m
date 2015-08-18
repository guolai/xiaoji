//
//  KTPhotoScrollViewController.m
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/4/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTPhotoScrollViewController2.h"
#import "KTPhotoView.h"
#import "UIViewController+BackButton.h"
#import "BBUserDefault.h"
#import "FileManagerController.h"
#import "BBNavigationViewController.h"
#import "BB_BBImage.h"
#import "DataModel.h"
#import "SmartObject.h"

@implementation KTPhotoScrollViewController2

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self storePreviousNavBarAppearance];
    [self setNavBarAppearance:animated];
    _previousNavToolbarHidden = self.navigationController.toolbarHidden;
    [self startChromeDisplayTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self restorePreviousNavBarAppearance:animated];
    // Controls
    [self.navigationController.navigationBar.layer removeAllAnimations]; // Stop all animations on nav bar
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // Cancel any pending toggles from taps
     [[UIApplication sharedApplication] setStatusBarStyle:_previousStatusBarStyle animated:animated];
    [self cancelChromeDisplayTimer];
    [super viewWillDisappear:animated];
    
}

- (id)initWithImageArray:(NSArray *)array andStartWithPhotoAtIndex:(NSUInteger)index andLocalFile:(BOOL)bLocale
{
   if (self = [super init]) {
       bLocalFile_ = bLocale;
       startWithIndex_ = index;
       array_ = array;
       _didSavePreviousStateOfNavBar = NO;
       self.wantsFullScreenLayout = YES;
       self.hidesBottomBarWhenPushed = YES;
   }
   return self;
}

- (void)viewDidLoad
{
    [self showBackButton:NSLocalizedString(@"Home", nil) action:nil];
    if (self.strTitle) {
        [self showTitle:self.strTitle];
    }
//    [self showRigthButton:NSLocalizedString(@"Done", nil) withImage:nil highlightImge:nil andEvent:@selector(doneBtnPressed:)];
    CGRect scrollFrame = [self frameForPagingScrollView];
    scrollView_ = [[UIScrollView alloc] initWithFrame:scrollFrame];
    [scrollView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [scrollView_ setDelegate:self];
    BBINFO(@"%@, %@", NSStringFromCGRect(scrollView_.frame), NSStringFromCGRect(scrollView_.bounds));
    UIColor *backgroundColor = [UIColor blackColor];
    [scrollView_ setBackgroundColor:backgroundColor];
//    [scrollView_ setAutoresizesSubviews:YES];
    [scrollView_ setPagingEnabled:YES];
    [scrollView_ setShowsVerticalScrollIndicator:NO];
    [scrollView_ setShowsHorizontalScrollIndicator:NO];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [[self view] addSubview:scrollView_];
    photoCount_ = array_.count;
    [self setScrollViewContentSize];
    photoViews_ = [[NSMutableArray alloc] initWithCapacity:photoCount_];
    for (int i=0; i < photoCount_; i++) {
        [photoViews_ addObject:[NSNull null]];
    }
//    [self setScrollViewContentSize];
    [self setCurrentIndex:startWithIndex_];
    [self scrollToIndex:startWithIndex_];
    
    [super viewDidLoad];
}

//- (void)loadView 
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//    self.view = view;
//    float fOffset = self.navBarHeight;
//    float fHeight = self.height - fOffset;
//    if(OS_VERSION < 7.0){
//        fOffset = 0;
//        fHeight -= 20;
//    }
//    self.view.clipsToBounds = YES;
//
//
//}



- (void)scrollToIndex:(NSInteger)index 
{
   CGRect frame = scrollView_.frame;
   frame.origin.x = frame.size.width * index;
   frame.origin.y = 0;
   [scrollView_ scrollRectToVisible:frame animated:NO];
}

- (void)setScrollViewContentSize
{
   NSInteger pageCount = photoCount_;
   if (pageCount == 0) {
      pageCount = 1;
   }

   CGSize size = CGSizeMake(scrollView_.frame.size.width * pageCount, 
                            scrollView_.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
   [scrollView_ setContentSize:size];
}



#pragma mark -
#pragma mark Frame calculations
#define PADDING  10

- (CGRect)frameForPagingScrollView 
{
   CGRect frame = [[UIScreen mainScreen] bounds];
//    Vlog(@"%@", NSStringFromCGRect(frame));
   frame.origin.x -= PADDING;
   frame.size.width += (2 * PADDING);
   return CGRectIntegral(frame);
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index 
{
    CGRect bounds = [scrollView_ bounds];
    //BBINFO(@"%@", NSStringFromCGRect(bounds));
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return CGRectIntegral(pageFrame);
}


#pragma mark -
#pragma mark Photo (Page) Management

- (void)loadPhoto:(NSInteger)index
{
   if (index < 0 || index >= photoCount_) {
      return;
   }
   
   id currentPhotoView = [photoViews_ objectAtIndex:index];
   if (NO == [currentPhotoView isKindOfClass:[KTPhotoView class]]) {
      // Load the photo view.
//       [scrollView_ setBackgroundColor:[UIColor redColor]];
      CGRect frame = [self frameForPageAtIndex:index];
       BBINFO(@"%@", NSStringFromCGRect(frame));
      __block KTPhotoView *photoView = [[KTPhotoView alloc] initWithFrame:frame];
      [photoView setScroller:self];
      [photoView setIndex:index];
//      [photoView setBackgroundColor:[UIColor blueColor]];
       SmartObject *smartObject = [array_ objectAtIndex:index];
      if(bLocalFile_)
      {
          NSString *strSmartPath = [smartObject.strNotePath stringByAppendingPathComponent:smartObject.strFileName];
          [photoView setImage:[[UIImage alloc] initWithContentsOfFile:strSmartPath]];
      }
      else
      {
          
      }
      [scrollView_ addSubview:photoView];
      [photoViews_ replaceObjectAtIndex:index withObject:photoView];
   } else {
      // Turn off zooming.
      [currentPhotoView turnOffZoom];
   }
}

- (void)unloadPhoto:(NSInteger)index
{
   if (index < 0 || index >= photoCount_) {
      return;
   }
   
   id currentPhotoView = [photoViews_ objectAtIndex:index];
   if ([currentPhotoView isKindOfClass:[KTPhotoView class]]) {
      [currentPhotoView removeFromSuperview];
      [photoViews_ replaceObjectAtIndex:index withObject:[NSNull null]];
   }
}

- (void)setCurrentIndex:(NSInteger)newIndex
{
   currentIndex_ = newIndex;
   
   [self loadPhoto:currentIndex_];
   [self loadPhoto:currentIndex_ + 1];
   [self loadPhoto:currentIndex_ - 1];
   [self unloadPhoto:currentIndex_ + 2];
   [self unloadPhoto:currentIndex_ - 2];
}


#pragma mark -
#pragma mark Rotation Magic


- (void)layoutScrollViewSubviews
{
   [self setScrollViewContentSize];

   NSArray *subviews = [scrollView_ subviews];
   
   for (KTPhotoView *photoView in subviews) {
      CGPoint restorePoint = [photoView pointToCenterAfterRotation];
      CGFloat restoreScale = [photoView scaleToRestoreAfterRotation];
      [photoView setFrame:[self frameForPageAtIndex:[photoView index]]];
      [photoView setMaxMinZoomScalesForCurrentBounds];
      [photoView restoreCenterPoint:restorePoint scale:restoreScale];
   }
   
   // adjust contentOffset to preserve page location based on values collected prior to location
   CGFloat pageWidth = scrollView_.bounds.size.width;
   CGFloat newOffset = (firstVisiblePageIndexBeforeRotation_ * pageWidth) + (percentScrolledIntoFirstVisiblePage_ * pageWidth);
   scrollView_.contentOffset = CGPointMake(newOffset, 0);
   
}




#pragma mark -
#pragma mark Chrome Helpers

- (void)toggleChromeDisplay 
{
   [self toggleChrome:!_bshouldHideStatusBar];
}

- (void)toggleChrome:(BOOL)hide 
{
    _bshouldHideStatusBar = hide;
    [self cancelChromeDisplayTimer];

    
    BOOL slideAndFade;
    if(OS_VERSION >= 7.0)
    {
        slideAndFade = YES;
    }
    CGFloat animationDuration = 0.35;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:_bshouldHideStatusBar withAnimation:UIStatusBarAnimationSlide];
    } else {
        
        // Status bar and nav bar positioning
        if (self.wantsFullScreenLayout) {
            
            // Need to get heights and set nav bar position to overcome display issues
            
            // Get status bar height if visible
            CGFloat statusBarHeight = 0;
            if (![UIApplication sharedApplication].statusBarHidden) {
                CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
                statusBarHeight = MIN(statusBarFrame.size.height, statusBarFrame.size.width);
            }
            
            // Status Bar
            [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationFade];
            
            // Get status bar height if visible
            if (![UIApplication sharedApplication].statusBarHidden) {
                CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
                statusBarHeight = MIN(statusBarFrame.size.height, statusBarFrame.size.width);
            }
            
            // Set navigation bar frame
            CGRect navBarFrame = self.navigationController.navigationBar.frame;
            navBarFrame.origin.y = statusBarHeight;
            self.navigationController.navigationBar.frame = navBarFrame;
            
        }
        
    }
    
    [UIView animateWithDuration:animationDuration animations:^(void) {
        CGFloat alpha = hide ? 0 : 1;
        [self.navigationController.navigationBar setAlpha:alpha];
    } completion:^(BOOL finished) {}];
   if (! _bshouldHideStatusBar ) {
      [self startChromeDisplayTimer];
   }
}

- (void)hideChrome 
{
   if (chromeHideTimer_ && [chromeHideTimer_ isValid]) {
      [chromeHideTimer_ invalidate];
      chromeHideTimer_ = nil;
   }
   [self toggleChrome:YES];
}

- (void)showChrome 
{
   [self toggleChrome:NO];
}

- (void)startChromeDisplayTimer 
{
   [self cancelChromeDisplayTimer];
   chromeHideTimer_ = [NSTimer scheduledTimerWithTimeInterval:8.0
                                                       target:self 
                                                     selector:@selector(hideChrome)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void)cancelChromeDisplayTimer 
{
   if (chromeHideTimer_) {
      [chromeHideTimer_ invalidate];
      chromeHideTimer_ = nil;
   }
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
   CGFloat pageWidth = scrollView.frame.size.width;
   float fractionalPage = scrollView.contentOffset.x / pageWidth;
   NSInteger page = floor(fractionalPage);
	if (page != currentIndex_) {
		[self setCurrentIndex:page];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
   [self hideChrome];
}



#pragma mark ---event

- (void)doneBtnPressed:(id)sender
{
//    SmartCardObject *smtObject = [array_ objectAtIndex:currentIndex_];
//    NSString *strmartPath = [DataModel getSmartCardPath];
//    if([FileManagerController fileExist:[strmartPath stringByAppendingPathComponent:smtObject.strBigFileName]])
//    {
//        [self cancelChromeDisplayTimer];
//        self.assetPickerState.strValue = smtObject.strBigFileName;
//        self.assetPickerState.state = BBAssetPikerStatePikingDoneSmart;
//    }
//   else
//   {
//       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Featured Card", nil) message:NSLocalizedString(@"Please wait the card download commpleted", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
//       [alert show];
////       [self showProgressHUDWithStr:NSLocalizedString(@"Please wait the card download commpleted", nil) hideafterDelay:2.0];
//   }
}



- (void)nextPhoto 
{
   [self scrollToIndex:currentIndex_ + 1];
   [self startChromeDisplayTimer];
}

- (void)previousPhoto 
{
   [self scrollToIndex:currentIndex_ - 1];
   [self startChromeDisplayTimer];
}

- (BOOL)prefersStatusBarHidden
{
    return _bshouldHideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}


#pragma mark - Nav Bar Appearance

- (void)setNavBarAppearance:(BOOL)animated {
    if(self.navigationController)
    {
        if(OS_VERSION >= 7.0)
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    UINavigationBar *navBar = self.navigationController.navigationBar;

    navBar.translucent = YES;
    navBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)storePreviousNavBarAppearance {
    _didSavePreviousStateOfNavBar = YES;
    if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]) {
        _previousNavBarBarTintColor = self.navigationController.navigationBar.barTintColor;
    }
    _previousNavBarTranslucent = self.navigationController.navigationBar.translucent;
    _previousNavBarTintColor = self.navigationController.navigationBar.tintColor;
    _previousNavBarHidden = self.navigationController.navigationBarHidden;
    _previousNavBarStyle = self.navigationController.navigationBar.barStyle;
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        _previousNavigationBarBackgroundImageDefault = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
        _previousNavigationBarBackgroundImageLandscapePhone = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsLandscapePhone];
    }
}

- (void)restorePreviousNavBarAppearance:(BOOL)animated {
    if (_didSavePreviousStateOfNavBar) {
        [self.navigationController setNavigationBarHidden:_previousNavBarHidden animated:animated];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        navBar.tintColor = _previousNavBarTintColor;
        navBar.translucent = _previousNavBarTranslucent;
        if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]) {
            navBar.barTintColor = _previousNavBarBarTintColor;
        }
        navBar.barStyle = _previousNavBarStyle;
        if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
            [navBar setBackgroundImage:_previousNavigationBarBackgroundImageDefault forBarMetrics:UIBarMetricsDefault];
            [navBar setBackgroundImage:_previousNavigationBarBackgroundImageLandscapePhone forBarMetrics:UIBarMetricsLandscapePhone];
        }
    }
}

@end
