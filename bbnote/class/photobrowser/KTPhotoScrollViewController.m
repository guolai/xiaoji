//
//  KTPhotoScrollViewController.m
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/4/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTPhotoScrollViewController.h"
#import "KTPhotoView.h"
#import "Constant.h"
#import "UIViewController+BackButton.h"
#import "BB_BBImage.h"
#import "BB_BBRecord.h"
#import "NSNumber+Sort.h"
#import "NSDate+String.h"
#import "BBUserDefault.h"
#import "BBMisc.h"
#import "DataModel.h"
#import "BBNavigationViewController.h"
#import "MediaViewController.h"
#import "TextViewController.h"

const CGFloat ktkDefaultPortraitToolbarHeight   = 44;
const CGFloat ktkDefaultLandscapeToolbarHeight  = 33;
const CGFloat ktkDefaultToolbarHeight = 40 + 24;

#define BUTTON_DELETEPHOTO 0
#define BUTTON_CANCEL 1

@implementation ScrRecord
@synthesize iArrayIndex;
@synthesize iTotalCout;
@synthesize index;
@synthesize iTotalIndex;
@synthesize strUUid;
@synthesize arrayData;
@synthesize date;
@synthesize strMood;
@synthesize iMoodCount;

@end

@implementation KTPhotoScrollViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    [self storePreviousNavBarAppearance];
    [self setNavBarAppearance:animated];
    [self setScrollViewContentSize];
    [self reloadImages];
    [self scrollToIndex:curRecord_.iTotalIndex];
    
    [self setTitleWithCurrentPhotoIndex];
    [self changeBrowserOrder];
    [self toggleNavButtons];
    [self startChromeDisplayTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Reset nav bar translucency and status bar style to whatever it was before.
    bWillDisappear_ = YES;
    [self restorePreviousNavBarAppearance:animated];
    [self.navigationController.navigationBar.layer removeAllAnimations]; // Stop all animations on nav bar
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // Cancel any pending toggles from taps
    [self cancelChromeDisplayTimer];
//    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle_ animated:YES];
    [super viewWillDisappear:animated];
}


- (id)initWithImageArray:(NSMutableArray *)array andStartWithPhotoAtIndex:(NSUInteger)index andLocalFile:(BOOL)bLocale
{
   if (self = [super init]) {
       BBINFO(@"%d", index);
       bLocalFile_ = bLocale;
       array_ = array;
       photoCount_ = 0;
       int iTotalIndex = 0;
       curRecord_ = [[ScrRecord alloc] init];
       priRecord_ = [[ScrRecord alloc] init];
       nextRecord_ = [[ScrRecord alloc] init];
       { //init currecord
//           for (BBRecord *bbrecord in array_)
           for (int i = 0; i < array_.count;)
           {
               BB_BBRecord *bbrecord = [array_ objectAtIndex:i];
               NSArray *arrayImg = [bbrecord.imageInRecord allObjects];
               if(arrayImg.count < 1)
               {
                   BB_BBText *bbtext = bbrecord.contentInRecord;
                   BBINFO(@"%@", bbtext);
                   BBINFO(@"%@", bbtext.text);
                   [array_ removeObjectAtIndex:i];
                   [bbrecord delete];
                   continue;
                   BBDEALLOC();
                   NSAssert(false, @"image array ");
               }
               i++;
               photoCount_ += arrayImg.count;
           }
           for (int i = 0;  i < index; i++) {
               BB_BBRecord *rcd = [array_ objectAtIndex:i];
               NSArray *arimg = [rcd.imageInRecord allObjects];
               iTotalIndex += arimg.count;
           }
           curRecord_.iTotalIndex = iTotalIndex;
           curRecord_.index = index;
           BB_BBRecord *record = [array_ objectAtIndex:index];
           curRecord_.arrayData = [self getImgArrayatIndex:index];
           curRecord_.iMoodCount = [record.mood_count intValue];
           curRecord_.date = record.create_date;
           curRecord_.strUUid = record.key;
           curRecord_.strMood = [BB_BBRecord getRecordMoodStr:record];
           curRecord_.iArrayIndex = 0;
           curRecord_.iTotalCout = curRecord_.arrayData.count;
       }

       [self setWantsFullScreenLayout:YES];

   }
   return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setScrollViewContentSize];
    photoViews_ = [[NSMutableArray alloc] initWithCapacity:photoCount_];
    for (int i=0; i < photoCount_; i++) {
        [photoViews_ addObject:[NSNull null]];
    }
    [self showBackButton:NSLocalizedString(@"Back", nil)  action:nil];
    [self showRigthButton:NSLocalizedString(@"More", nil) withImage:nil highlightImge:nil andEvent:@selector(moreBtnPressed)];
    
}

- (void)loadView 
{
    [super loadView];
 
    CGRect scrollFrame = [self frameForPagingScrollView];
    scrollView_ = [[UIScrollView alloc] initWithFrame:scrollFrame];
    [scrollView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [scrollView_ setDelegate:self];
    BBINFO(@"%@, %@", NSStringFromCGRect(scrollView_.frame), NSStringFromCGRect(scrollView_.bounds));
    [scrollView_ setBackgroundColor:[UIColor blackColor]];
    [scrollView_ setAutoresizesSubviews:YES];
    [scrollView_ setPagingEnabled:YES];
    [scrollView_ setShowsVerticalScrollIndicator:NO];
    [scrollView_ setShowsHorizontalScrollIndicator:NO];

    [[self view] addSubview:scrollView_];


    CGRect toolbarFrame = CGRectMake(0, 
                                self.view.bounds.size.height - ktkDefaultToolbarHeight,
                                self.view.bounds.size.width,
                                ktkDefaultToolbarHeight);
    toolbar_ = [[BBTitleView alloc] initWithFrame:toolbarFrame];
    [[self view] addSubview:toolbar_];
    BB_BBRecord *record = [array_ objectAtIndex:curRecord_.index];
    [toolbar_ setrecord:record];

}

#pragma mark dta index invoke

- (NSMutableArray *)getImgArrayatIndex:(int)index
{
    BB_BBRecord *record = [array_ objectAtIndex:index];
    NSMutableArray *arryImg = [NSMutableArray arrayWithArray:[record.imageInRecord allObjects]];
    [arryImg sortedArrayUsingFunction:compareImages context:nil];
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:arryImg.count];
    for (BB_BBImage *img  in arryImg) {
       
        if([img.iscontent boolValue])
        {
            [tmpArray  insertObject:img atIndex:0];
//            BBINFO(@"before %@", arryImg);
//            [arryImg removeObject:img];
//            [arryImg insertObject:img atIndex:0];
//            [img release];
//            BBINFO(@"after %@", arryImg);
            //assert(false);
            //break;
        }
        else
        {
             [tmpArray addObject:img];
        }
    }
    //return arryImg;
    return tmpArray;
}

- (NSString *)getPriImage
{
    NSString *strImg = nil;
    int iIndex = curRecord_.iArrayIndex - 1;
    if(iIndex < 0) //寻找前一条记录
    {
        if(curRecord_.index <= 0) //已经到所有记录的第一条
            return strImg;
        priRecord_.index = curRecord_.index - 1;
        priRecord_.arrayData = [self getImgArrayatIndex:priRecord_.index];
        BB_BBRecord *record = [array_ objectAtIndex:priRecord_.index];
        priRecord_.iMoodCount = [record.mood_count intValue];
        priRecord_.date = record.create_date;
        priRecord_.strUUid = record.key;
        priRecord_.strMood = [BB_BBRecord getRecordMoodStr:record];
        priRecord_.iTotalCout = priRecord_.arrayData.count;
        priRecord_.iTotalIndex = curRecord_.iTotalIndex - priRecord_.iTotalCout;
        priRecord_.iArrayIndex = priRecord_.iTotalCout - 1;
        BB_BBImage *imge = [priRecord_.arrayData objectAtIndex:priRecord_.iArrayIndex];
        strImg = imge.data_path;
        NSString *strFolder = [DataModel getNotePath:record];
        strImg = [strFolder stringByAppendingPathComponent:strImg];
    }
    else
    {
        BB_BBImage *imge = [curRecord_.arrayData objectAtIndex:iIndex];
        strImg = imge.data_path;
        BB_BBRecord *record = [array_ objectAtIndex:curRecord_.index];
        NSString *strFolder = [DataModel getNotePath:record];
        strImg = [strFolder stringByAppendingPathComponent:strImg];
    }
    return strImg;
}

- (NSString *)getCurImage
{
    NSString *strImg = nil;
    BB_BBImage *imge = [curRecord_.arrayData objectAtIndex:curRecord_.iArrayIndex];
    strImg = imge.data_path;
    BB_BBRecord *record = [array_ objectAtIndex:curRecord_.index];
    NSString *strFolder = [DataModel getNotePath:record];
    strImg = [strFolder stringByAppendingPathComponent:strImg];
    return strImg;
}

- (NSString *)getNextImage
{
    NSString *strImg = nil;
    int iIndex = curRecord_.iArrayIndex + 1;
    if(iIndex >= curRecord_.iTotalCout) //寻找后一条记录
    {
        if(curRecord_.index >= array_.count - 1)//已经到所有记录的最后一条
            return strImg;
        nextRecord_.index = curRecord_.index + 1;
        nextRecord_.arrayData = [self getImgArrayatIndex:nextRecord_.index];
        BB_BBRecord *record = [array_ objectAtIndex:nextRecord_.index];
        nextRecord_.iMoodCount = [record.mood_count intValue];
        nextRecord_.date = record.create_date;
        nextRecord_.strUUid = record.key;
        nextRecord_.strMood = [BB_BBRecord getRecordMoodStr:record];
        nextRecord_.iTotalCout = nextRecord_.arrayData.count;
        nextRecord_.iTotalIndex = curRecord_.iTotalIndex + curRecord_.iTotalCout;
        nextRecord_.iArrayIndex = 0;
        BB_BBImage *imge = [nextRecord_.arrayData objectAtIndex:nextRecord_.iArrayIndex];
        BBINFO(@"%@, %@", imge.data_path, imge.data_small_path);
        strImg = imge.data_path;
        NSString *strFolder = [DataModel getNotePath:record];
        strImg = [strFolder stringByAppendingPathComponent:strImg];
    }
    else
    {
        BB_BBImage *imge = [curRecord_.arrayData objectAtIndex:iIndex];
        strImg = imge.data_path;
        BB_BBRecord *record = [array_ objectAtIndex:curRecord_.index];
        NSString *strFolder = [DataModel getNotePath:record];
        strImg = [strFolder stringByAppendingPathComponent:strImg];
    }
    return strImg;
}

- (void)setTitleWithCurrentPhotoIndex
{
    NSString *formatString = NSLocalizedString(@"%1$i of %2$i", @"Picture X out of Y total.");
    NSString *strTitle = [NSString stringWithFormat:formatString, curRecord_.index + 1, array_.count, nil];
    NSString *strTime = [curRecord_.date qzGetDate];
    NSString *strWeek = [curRecord_.date qzGetWeek];
    [self showBrowsePicture:strTitle andMonthDay:strTime andWeek:strWeek];
}

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

- (void)toggleNavButtons 
{
//   [previousButton_ setEnabled:(currentIndex_ > 0)];
//   [nextButton_ setEnabled:(currentIndex_ < photoCount_ - 1)];
}


#pragma mark -
#pragma mark Frame calculations
#define PADDING  10

- (CGRect)frameForPagingScrollView 
{
   CGRect frame = [[UIScreen mainScreen] bounds];
    BBINFO(@"%@", NSStringFromCGRect(frame));
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
    if(pageFrame.size.width - 320.0f <= 0.0f)
    {
        pageFrame.size.height = [[UIScreen mainScreen] bounds].size.height;
    }
    //BBINFO(@"%@", NSStringFromCGRect(pageFrame));
    return pageFrame;
}


#pragma mark -
#pragma mark Photo (Page) Management

- (void)loadPhoto:(NSInteger)index withImagPath:(NSString *)strpath
{
   if (index < 0 || index >= photoCount_) {
      return;
   }
    BBINFO(@"%@", strpath);
   id currentPhotoView = [photoViews_ objectAtIndex:index];
   if (NO == [currentPhotoView isKindOfClass:[KTPhotoView class]]) {
      // Load the photo view.
      CGRect frame = [self frameForPageAtIndex:index];
      KTPhotoView *photoView = [[KTPhotoView alloc] initWithFrame:frame];
      [photoView setScroller:self];
      [photoView setIndex:index];
      [photoView setBackgroundColor:[UIColor clearColor]];
   
      if([[NSFileManager defaultManager] fileExistsAtPath:strpath])
      {
          [photoView setImage:[UIImage imageWithContentsOfFile:strpath]];
      }
      else
      {
          [photoView setImage:[UIImage imageNamed:@"qzphoto_browser_defaut.png"]];
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

- (void)reloadImages
{
    int iCurIndex = curRecord_.iTotalIndex + curRecord_.iArrayIndex;
    [self loadPhoto:iCurIndex withImagPath:[self getCurImage]];
    [self loadPhoto:iCurIndex - 1 withImagPath:[self getPriImage]];
    [self loadPhoto:iCurIndex + 1 withImagPath:[self getNextImage]];
    [self unloadPhoto:iCurIndex + 2];
    [self unloadPhoto:iCurIndex - 2];
    [self toggleNavButtons];
}

#pragma mark -
#pragma mark Rotation Magic

- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
   CGRect toolbarFrame = toolbar_.frame;
   if ((interfaceOrientation) == UIInterfaceOrientationPortrait || (interfaceOrientation) == UIInterfaceOrientationPortraitUpsideDown)
   {
       toolbarFrame.size.height = ktkDefaultPortraitToolbarHeight;
       toolbarFrame.size.width = SCR_WIDTH;
       toolbarFrame.origin.y =  SCR_HEIGHT_P - 20 - toolbarFrame.size.height;
   } else {
       toolbarFrame.size.height = ktkDefaultLandscapeToolbarHeight+1;
       toolbarFrame.size.width = SCR_HEIGHT_P;
       toolbarFrame.origin.y =  SCR_WIDTH - 20 - toolbarFrame.size.height;
   }
    BBINFO(@"%f, %f", SCR_WIDTH, SCR_HEIGHT);

   toolbar_.frame = toolbarFrame;
}

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

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{

    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                duration:(NSTimeInterval)duration 
{
   CGFloat offset = scrollView_.contentOffset.x;
   CGFloat pageWidth = scrollView_.bounds.size.width;
   
   if (offset >= 0) {
      firstVisiblePageIndexBeforeRotation_ = floorf(offset / pageWidth);
      percentScrolledIntoFirstVisiblePage_ = (offset - (firstVisiblePageIndexBeforeRotation_ * pageWidth)) / pageWidth;
   } else {
      firstVisiblePageIndexBeforeRotation_ = 0;
      percentScrolledIntoFirstVisiblePage_ = offset / pageWidth;
   }    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration 
{
   [self layoutScrollViewSubviews];
   // Rotate the toolbar.
   [self updateToolbarWithOrientation:toInterfaceOrientation];
   
   // Adjust navigation bar if needed.
//   if (isChromeHidden_ && statusbarHidden_ == NO) {
//      UINavigationBar *navbar = [[self navigationController] navigationBar];
//      CGRect frame = [navbar frame];
//      frame.origin.y = 20;
//      [navbar setFrame:frame];
//   }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
   [self startChromeDisplayTimer];
}


#pragma mark -
#pragma mark Chrome Helpers
- (void)toggleChromeDisplay
{
   [self toggleChrome:!_bshouldHideStatusBar];
}

- (void)toggleChrome:(BOOL)hide
{
    if(bWillDisappear_ && hide)
        return;
    _bshouldHideStatusBar = hide;
    [self cancelChromeDisplayTimer];
    CGFloat animationDuration = 0.35;

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:_bshouldHideStatusBar withAnimation:UIStatusBarAnimationSlide];
        [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationSlide];
    }
    else
    {
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
            [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationSlide];
            
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
    if(hide)
    {

        [UIView animateWithDuration:animationDuration animations:^(void) {
            [self.navigationController.navigationBar setAlpha:0.0f];
            [toolbar_ setAlpha:0.0f];
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        
        [UIView animateWithDuration:animationDuration animations:^(void) {
            [self.navigationController.navigationBar setAlpha:1.0];
            [toolbar_ setAlpha:1.0f];
        } completion:^(BOOL finished) {
        
        }];
    }
    
    if (!_bshouldHideStatusBar)
    {
        [self startChromeDisplayTimer];
    }

}

- (void)hideChrome
{
    [self cancelChromeDisplayTimer];
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
   if (chromeHideTimer_)
   {
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
	if (page != curRecord_.iTotalIndex) {
        if(page < curRecord_.iTotalIndex) // pri note
        {
            curRecord_.iArrayIndex = 0;
            if([self getPriImage])
            {
                [self copyRecord:priRecord_ to:curRecord_];
                curRecord_.iArrayIndex = page - curRecord_.iTotalIndex;
                [self checkCurentRecord];
                BB_BBRecord *record = [array_ objectAtIndex:curRecord_.index];
                [toolbar_ setrecord:record];
                [self setTitleWithCurrentPhotoIndex];
            }
        }
        else if(page >= curRecord_.iTotalIndex + curRecord_.iTotalCout) // next note
        {
            curRecord_.iArrayIndex = curRecord_.iTotalCout - 1;
            if([self getNextImage])
            {
                [self copyRecord:nextRecord_ to:curRecord_];
                curRecord_.iArrayIndex = page - curRecord_.iTotalIndex;
                [self checkCurentRecord];
                BB_BBRecord *record = [array_ objectAtIndex:curRecord_.index];
                [toolbar_ setrecord:record];
                [self setTitleWithCurrentPhotoIndex];
            }
        }
        else
        {
            curRecord_.iArrayIndex = page - curRecord_.iTotalIndex;
            [self checkCurentRecord];
        }
        [self changeBrowserOrder];
		[self reloadImages];
	}
}

- (void)checkCurentRecord
{
    if(curRecord_.iArrayIndex >= curRecord_.iTotalCout)
    {
        //assert(false);
        curRecord_.iArrayIndex = curRecord_.iTotalCout - 1;
    }
    if(curRecord_.iArrayIndex < 0)
    {
        //assert(false);
        curRecord_.iArrayIndex = 0;
    }
}

- (void)copyRecord:(ScrRecord *)fromrcd to:(ScrRecord *)torcd
{
    torcd.index = fromrcd.index;
    torcd.arrayData = fromrcd.arrayData;
    torcd.date = fromrcd.date;
    torcd.strUUid = fromrcd.strUUid;
    torcd.strMood = fromrcd.strMood;
    torcd.iTotalCout = fromrcd.iTotalCout;
    torcd.iTotalIndex = fromrcd.iTotalIndex;
    torcd.iArrayIndex = fromrcd.iArrayIndex;
    torcd.iMoodCount = fromrcd.iMoodCount;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   [self hideChrome];
}



#pragma mark ---event

- (void)moreBtnPressed
{
    [self cancelChromeDisplayTimer];
    UIActionSheet *acctionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle", nil) destructiveButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles:NSLocalizedString(@"Save to Ablums", nil), NSLocalizedString(@"Reedit", nil), nil];
    acctionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [acctionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self dismissProgressHUD];
//    if(!error)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"save ptoto failed:%@", error.description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
}

- (void)saveCurrentPhotoToAblums
{
    [self showProgressHUDWithStr:NSLocalizedString(@"Saving...", nil) hideafterDelay:2];
    NSString *strFileName = [self getCurImage];
    if([[NSFileManager defaultManager] fileExistsAtPath:strFileName])
    {
        UIImage *img = [UIImage imageWithContentsOfFile:strFileName];
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)deleteCurrentPhoto
{
    if(curRecord_.iTotalCout == 1 || curRecord_.iArrayIndex == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Are you sure to delete the whole note?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alertView show];
        return;
    }
    [BBUserDefault setHomeViewIndex:-1];
    NSInteger photoIndexToDelete = curRecord_.iTotalIndex + curRecord_.iArrayIndex;
    [self unloadPhoto:photoIndexToDelete];
    [self unloadPhoto:photoIndexToDelete + 1];
    
    BB_BBImage *bbimage = [curRecord_.arrayData objectAtIndex:curRecord_.iArrayIndex];
    [BBMisc deleteImageFileOfCoredata:bbimage];
    [bbimage delete];
    [curRecord_.arrayData removeObjectAtIndex:curRecord_.iArrayIndex];
    curRecord_.iTotalCout = curRecord_.iTotalCout - 1;
    [self checkCurentRecord];
    [self changeBrowserOrder];

    //按理说array里面的数据也被删了
    
//    BBRecord *bbrecord = [array_ objectAtIndex:curRecord_.index];
//    for (BBImage *bbimg  in [bbrecord.imageInRecord allObjects]) {
//        if(bbimg.data_small_path isEqualToString:[)
//    }
//   

    
    photoCount_ -= 1;
    if (photoCount_ == 0) {
        [self showChrome];
        [[self navigationController] popViewControllerAnimated:YES];
    } else {
        NSInteger nextIndex = photoIndexToDelete;
        if (nextIndex == photoCount_) {
            nextIndex -= 1;
        }
        [self reloadImages];
        [self setScrollViewContentSize];
    }
}

- (void)deleteWholeNote
{
    [BBUserDefault setHomeViewIndex:-1];
    NSInteger photoIndexToDelete = curRecord_.iTotalIndex + curRecord_.iArrayIndex;
    [self unloadPhoto:photoIndexToDelete - 1];
    [self unloadPhoto:photoIndexToDelete];
    [self unloadPhoto:photoIndexToDelete + 1];
    BB_BBRecord *bbrecord = [array_ objectAtIndex:curRecord_.index];
    [BBMisc deleteRecordFileOfCoredata:bbrecord];
    [bbrecord delete];
    [array_ removeObjectAtIndex:curRecord_.index];
    if(curRecord_.index == 0 && array_.count < 1)
    {
        [self popViewController];
        return;
    }
    photoCount_ -= curRecord_.iTotalCout;
    if (photoCount_ == 0) {
        [self popViewController];
        return;
    }

    if(curRecord_.index == array_.count)
    {
        curRecord_.index = array_.count - 1;
    }
//    photoCount_ = 0;
    int iTotalIndex = 0;

    for (int i = 0;  i < curRecord_.index; i++) {
        BB_BBRecord *rcd = [array_ objectAtIndex:i];
        NSArray *arimg = [rcd.imageInRecord allObjects];
        iTotalIndex += arimg.count;
    }
//    assert(iTotalIndex == curRecord_.iTotalIndex - curRecord_.iTotalCout);
    curRecord_.iTotalIndex = iTotalIndex;
    BB_BBRecord *record = [array_ objectAtIndex:curRecord_.index];
    curRecord_.arrayData = [self getImgArrayatIndex:curRecord_.index];
    curRecord_.iMoodCount = [record.mood_count intValue];
    curRecord_.date = record.create_date;
    curRecord_.strUUid = record.key;
    curRecord_.strMood = [BB_BBRecord getRecordMoodStr:record];
    curRecord_.iArrayIndex = 0;
    curRecord_.iTotalCout = curRecord_.arrayData.count;
    [toolbar_ setrecord:record];
    [self changeBrowserOrder];
    [self reloadImages];
    [self setScrollViewContentSize];
}

- (void)changeBrowserOrder
{
    NSString *strOrder = [NSString stringWithFormat:@"%d/%d", curRecord_.iArrayIndex + 1, curRecord_.iTotalCout];
    [toolbar_ setpageOrder:strOrder];
}

- (void)popViewController
{
    [BBUserDefault setHomeViewIndex:-1];
    [self showChrome];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Delete", nil)])
    {
        [self deleteCurrentPhoto];
    }
    else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Save to Ablums", nil)])
    {
        [self saveCurrentPhotoToAblums];
    }
    else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Reedit", nil)])
    {
        BB_BBRecord *record = [array_ objectAtIndex:curRecord_.index];
        MediaViewController  *vc = [[MediaViewController alloc] initWithNote:record];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [self startChromeDisplayTimer];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"OK", nil)])
    {
        [self deleteWholeNote];
    }
    else
    {
    
    }
}

#pragma mark - statubar 
- (BOOL)prefersStatusBarHidden
{
    return _bshouldHideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

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
