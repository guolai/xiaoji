//
//  EditHeadView.h
//  Zine
//
//  Created by user1 on 13-7-30.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EditHeadTagBar,
    EditHeadPhotoBar,
    EditHeadMapBar,
    EditHeadVideoBar,
    EditHeadBrushBar,
    EditHeadFinishEditBar
}EditHeadToolbarType;

@protocol EditHeadToolbarDelegate <NSObject>

@required

- (void)headToolbarSelected:(UIButton*)sender type:(EditHeadToolbarType)type;

@end

@interface EditHeadView : UIView {
    UIImageView* _autoSaveView;
    UIButton* _finishEditBtn;
}

@property (nonatomic, weak) id<EditHeadToolbarDelegate> delegate;

- (void)startAutoSaveAnimate;
- (void)stopAutoSaveAnimate;

@end


@interface  LoadProgressView: UIView
{
    float _fProgress;
}

-(void)setCurrentProgress:(float)fProgrss;


@end
