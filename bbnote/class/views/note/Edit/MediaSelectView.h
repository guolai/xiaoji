//
//  MediaSelectView.h
//  Zine
//
//  Created by bob on 12/5/13.
//  Copyright (c) 2013 aura marker stdio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    e_Media_Photo,
    e_Media_Paper,
    e_Media_Max
}T_Media_Type;

@protocol MediaSelectDelegate <NSObject>
- (void)mediaSelectDidSelect:(T_Media_Type)iType;
@end


@interface MediaSelectView : UIView
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, weak) id<MediaSelectDelegate> delegate;
@end
