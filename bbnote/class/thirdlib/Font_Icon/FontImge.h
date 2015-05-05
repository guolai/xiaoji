//
//  FontImge.h
//  helpevernote
//
//  Created by bob on 4/11/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
@interface FontImge : UIImageView
@property (nonatomic, strong) UIColor *iconImgColor;
@property (nonatomic, strong) UIColor *bgViewColor;
@property (nonatomic, assign) FAIcon iconName;
@end
