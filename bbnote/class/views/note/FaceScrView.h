//
//  FaceScrView.h
//  bbnote
//
//  Created by Apple on 13-5-8.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceClickDelegate;
@class GrayPageControl;

@interface FaceScrView : UIView<UIScrollViewDelegate>
{
    @private
    int iTag_;
    GrayPageControl *pageControl_;
    UIScrollView *scrView_;
}
@property (nonatomic, assign) id<FaceClickDelegate> facedelegate;
@property (nonatomic, assign) BOOL isHiden;
- (id)initWithDelegate:(id<FaceClickDelegate>)dele;

@end

@protocol FaceClickDelegate <NSObject>

- (void)faceclickAtIndex:(unsigned int)index;

@end


@interface GrayPageControl : UIPageControl
{
    UIImage *activeImage;
    UIImage *inactiveImage;
}

@end