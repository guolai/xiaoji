//
//  LockViewController.m
//  Zine
//
//  Created by bob on 11/12/13.
//  Copyright (c) 2013 aura marker stdio. All rights reserved.
//

#import "LockViewController.h"
#import "BBUserDefault.h"

@interface LockViewController ()
{
    UILabel *_lblPrompt;
    UILabel *_lblMessage;
    UITextField *_passwrodTextField;
    NSMutableArray *_dotArray;
    UIImageView *_contentView;
    int _iTry;
    BOOL _bShouldHideStatusBar;
    int _iStautsBarStyle;
}
@end

@implementation LockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetAllStatus];
    _iTry = 0;
    _bShouldHideStatusBar = [UIApplication sharedApplication].statusBarHidden;
    _iStautsBarStyle = [UIApplication sharedApplication].statusBarStyle;
}

- (void)dismissCurrentView
{
    if(self.lockViewDelegate && [self.lockViewDelegate respondsToSelector:@selector(lockViewControllerDidCancle:)])
    {
        [self.lockViewDelegate lockViewControllerDidCancle:Nil];
    }
}

- (void)getFocus:(BOOL)bvalue
{
    if(bvalue)
    {
        [_passwrodTextField becomeFirstResponder];
    }
    else
    {
        [_passwrodTextField resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _passwrodTextField.text = @"";
//    [_passwrodTextField becomeFirstResponder];
    _iTry = 0;
    [self resetAllStatus];
    [_contentView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"skin%d", (int)(arc4random() % 3) + 1]]];
    
    self.bPresented = YES;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view = view;
    float fTopSpace = 42.0 * fScr_Scale;
    if(OS_VERSION >= 7.0)
        fTopSpace += 64;
    
    _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_contentView];
    
    _dotArray = [[NSMutableArray alloc] initWithCapacity:4];
    _lblPrompt = [[UILabel alloc] initWithFrame:CGRectMake(50 * fScr_Scale, fTopSpace, 220 * fScr_Scale, 20 * fScr_Scale)];
    [_lblPrompt setBackgroundColor:[UIColor clearColor]];
    [_lblPrompt setTextAlignment:NSTextAlignmentCenter];
    [_lblPrompt setFont:[UIFont systemFontOfSize:14 * fScr_Scale]];
    [_contentView addSubview:_lblPrompt];
    
    float fLeftSpace = 40.0 * fScr_Scale;
    if(isPhone6)
    {
        fLeftSpace += 10;
    }
    fTopSpace += (40 * fScr_Scale);
    UIImage *bgImg = [UIImage imageNamed:@"lock_rectangle.png"];
    UIImage *dotImg = [UIImage imageNamed:@"lock_elipse.png"];
    for (int i = 0; i < 4; i++)
    {
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake( fLeftSpace + 60 * i * fScr_Scale, fTopSpace, bgImg.size.width, bgImg.size.height)];
        [imgview setImage:bgImg];
        [_contentView addSubview:imgview];
        
        float fAdd = bgImg.size.width - dotImg.size.width;
        fAdd = fAdd / 2;
        UIImageView *dotImgView = [[UIImageView alloc] initWithFrame:CGRectMake(fLeftSpace + fAdd * fScr_Scale  + 60 * i * fScr_Scale, fTopSpace + fAdd, dotImg.size.width, dotImg.size.height)];
        [dotImgView setImage:dotImg];
        [_contentView addSubview:dotImgView];
        [_dotArray addObject:dotImgView];
    }
    
    _lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(20 * fScr_Scale, fTopSpace + bgImg.size.height + 30 * fScr_Scale, 280 * fScr_Scale, 60 * fScr_Scale)];
    [_lblMessage setBackgroundColor:[UIColor clearColor]];
    [_lblMessage setTextColor:[UIColor redColor]];
    [_lblMessage setTextAlignment:NSTextAlignmentCenter];
    [_lblMessage setFont:[UIFont systemFontOfSize:18 * fScr_Scale]];
    [_lblMessage setNumberOfLines:2];
    [_contentView addSubview:_lblMessage];
    
    
    
    _passwrodTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100 * fScr_Scale, 20 * fScr_Scale)];
    _passwrodTextField.secureTextEntry = YES;
    _passwrodTextField.textColor = [UIColor colorWithRed:0.23 green:0.33 blue:0.52 alpha:1.0];
    _passwrodTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_passwrodTextField addTarget:self action:@selector(passcodeChanged:) forControlEvents:UIControlEventEditingChanged];
    [_contentView addSubview:_passwrodTextField];

    _passwrodTextField.hidden = YES;
    
}

- (void)resetAllStatus
{

    _lblPrompt.text = NSLocalizedString(@"Enter the password protection", Nil);
  
    for (int i = 0; i < _dotArray.count; i++) {
        UIImageView *imgView = [_dotArray objectAtIndex:i];
        imgView.hidden = YES;
    }
}

#pragma mark ---event
- (void)passcodeChanged:(id)sender {
    NSString *text = _passwrodTextField.text;
    
    if ([text length] > 4) {
        text = [text substringToIndex:4];
    }
    for (int i=0;i<4;i++) {
        UIImageView *imgView = [_dotArray objectAtIndex:i];
        imgView.hidden = i >= [text length];
    }
    if ([text length] == 4) {
        [self handleCompleteField];
    }
    
}
- (void)handleCompleteField {
    NSString *text = _passwrodTextField.text;
    NSString *strPassword = [BBUserDefault getProtectPassword];

    if ([text isEqualToString:strPassword]) {
      if(self.lockViewDelegate && [self.lockViewDelegate respondsToSelector:@selector(lockViewControllerDidEnter:)])
      {
          [_passwrodTextField becomeFirstResponder];
          [self.lockViewDelegate lockViewControllerDidEnter:self];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [self resetAllStatus];
          });
      }
    }
    else
    {
        if(_iTry >= 25)
        {
            if(self.lockViewDelegate && [self.lockViewDelegate respondsToSelector:@selector(lockViewControllerDidCancle:)])
            {
                [self.lockViewDelegate lockViewControllerDidCancle:Nil];
            }
            return;
        }
        _iTry++;
        NSString *strMsg = [NSString stringWithFormat:@"%@, %@ %d %@", NSLocalizedString(@"The passwords don't match", nil), NSLocalizedString(@"You have", nil), 25 - _iTry, NSLocalizedString(@"Times", nil)];
        _passwrodTextField.text = @"";
        _lblMessage.text =strMsg;
        [self resetAllStatus];
       // [self showBouncingAnimation:_contentView];
    }
}

- (void)showBouncingAnimation:(UIView *)bouncingView
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	//bounceAnimation.removedOnCompletion = NO;
	
	CGFloat animationDuration = 0.3;
    
	
	// Create the path for the bounces
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	CGFloat midX = bouncingView.center.x;
	CGFloat midY = bouncingView.center.y + 5;
	CGFloat originalOffsetX = bouncingView.center.x - midX;
	CGFloat originalOffsetY = bouncingView.center.y - midY;
	CGFloat offsetDivider = 4.0f;
	
	BOOL stopBouncing = NO;
	
	// Start the path at the placard's current location
	CGPathMoveToPoint(thePath, NULL, bouncingView.center.x, bouncingView.center.y);
//	CGPathAddLineToPoint(thePath, NULL, midX, midY);
	
	// Add to the bounce path in decreasing excursions from the center
	while (stopBouncing != YES) {
        //BBINFO(@"%d", abs(originalOffsetX/offsetDivider));
        if(abs(originalOffsetX/offsetDivider) < 8)
        {
            CGPathAddLineToPoint(thePath, NULL, bouncingView.center.x, bouncingView.center.y + originalOffsetY/offsetDivider);
            CGPathAddLineToPoint(thePath,  NULL, bouncingView.center.x, bouncingView.center.y - originalOffsetY/offsetDivider);
            
            if ((abs(originalOffsetX/offsetDivider) < 2) && (abs(originalOffsetY/offsetDivider) < 2)) {
                stopBouncing = YES;
            }
        }
        offsetDivider *= 4;
        
	}
	
	bounceAnimation.path = thePath;
	bounceAnimation.duration = animationDuration;
	CGPathRelease(thePath);
    [bouncingView.layer addAnimation:bounceAnimation forKey:@"bouncing"];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
