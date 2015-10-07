//
//  EditWebView.m
//  Zine
//
//  Created by user1 on 13-7-31.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import "EditWebView.h"
#import "EditAccessoryView.h"

@implementation EditWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)dealloc {
//    [_inputAccessoryViewView release];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    if (action == @selector(select:)) {
        return [super canPerformAction:action withSender:sender];
    }
    else if(action == @selector(paste:)){
        return [super canPerformAction:action withSender:sender];
    }
//    Vlog(@"%@", NSStringFromSelector(action));
    
    return NO;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/*
- (UIView*)inputAccessoryView {
    if (!_inputAccessoryViewView) {
        CGRect headViewRect = CGRectMake(0, 0, SCR_WIDTH, 44);
        _inputAccessoryViewView = [[EditAccessoryView alloc] initWithFrame:headViewRect];
    }
    return _inputAccessoryViewView;
}

- (void)setInputAccessoryView:(UIView *)inputAccessoryView {
    if (_inputAccessoryViewView == inputAccessoryView) {
        return;
    }
    
    if (_inputAccessoryViewView) {
        [_inputAccessoryViewView release];
    }
    _inputAccessoryViewView = inputAccessoryView;
    [_inputAccessoryViewView retain];
}
*/
@end
