//
//  FontImge.m
//  helpevernote
//
//  Created by bob on 4/11/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "FontImge.h"
#import "BBSkin.h"

@interface FontImge()
@property (nonatomic, strong) UILabel *defaultView;

@end

@implementation FontImge

@synthesize bgViewColor;
@synthesize iconImgColor;
@synthesize iconName;

- (UILabel*)defaultView
{
    if (nil != _defaultView)
        return _defaultView;
    
    //The size of the default view is the same of self
    _defaultView = [[UILabel alloc] initWithFrame:self.bounds];
    _defaultView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _defaultView.font = [UIFont fontWithName:@"FontAwesome" size:self.bounds.size.height];
    _defaultView.textAlignment = NSTextAlignmentLeft;
//    _defaultView.adjustsFontSizeToFitWidth = YES;
    
    //UIAppearance selectors
    _defaultView.textColor = [BBSkin shareSkin].bgTxtColor;
    _defaultView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_defaultView];
    
    return _defaultView;
}

- (void)setIconName:(FAIcon)iconName
{
    NSString *strIcon = [NSString stringFromAwesomeIcon:iconName];
    self.defaultView.text = strIcon;
    if(self.bgViewColor)
    {
        [self setBackgroundColor:self.bgViewColor];
    }
    if(self.iconImgColor)
    {
        self.defaultView.textColor = self.iconImgColor;
    }
}

@end
