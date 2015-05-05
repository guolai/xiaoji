//
//  ImagesBtnView.h
//  bbnote
//
//  Created by Apple on 13-4-9.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BImage.h"

@interface ImageButton : UIButton
@property (nonatomic, retain)BImage *bimage;
@property (nonatomic, strong) NSString *strNotePath;
@end


@protocol ImagesBtnDelegate;
@interface ImagesBtnView : UIView
{
    @private
    NSMutableArray *mutArray_;
    ImageButton *addImgBtn_;
    int iSpace_;
    int iLeftSapce_;
}
@property (nonatomic, assign) id<ImagesBtnDelegate> delegate;
@property (nonatomic, strong) NSString *strNotePath;
- (id)initWithObjects:(NSArray *)array;
- (void)deleteImageObject:(BImage *)bimge;
- (void)addImageObject:(BImage *)bimge;
- (void)removeImage:(NSString *)str;
@end

@protocol ImagesBtnDelegate<NSObject>
- (void)adjustViewFrame;
- (void)addImageBtnPressed;
- (void)pictureBtnPressed:(id)sender;
@end
