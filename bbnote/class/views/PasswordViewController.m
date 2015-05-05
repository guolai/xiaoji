//
//  PasswordViewController.m
//  Zine
//
//  Created by bob on 11/12/13.
//  Copyright (c) 2013 aura marker stdio. All rights reserved.
//

#import "PasswordViewController.h"
#import "BBUserDefault.h"
#import "AnimationHelper.h"


@interface PasswordViewController ()
{
    UILabel *_lblPrompt;
    UILabel *_lblMessage;
    UITextField *_passwrodTextField;
    NSMutableArray *_dotArray;
    BOOL _bRepeat;
    NSString *_strPassword;
    UIImageView *_contentView;
}
@end

@implementation PasswordViewController
@synthesize passwordDelegate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton:nil action:@selector(dismissCurrentView)];
    [self showTitle:NSLocalizedString(@"Lock password", nil)];
    _bRepeat = NO;
    [self resetAllStatus];
}

- (void)dismissCurrentView
{
    if(self.passwordDelegate && [self.passwordDelegate respondsToSelector:@selector(PasswordViewControllerDidCancle:)])
    {
        [self.passwordDelegate PasswordViewControllerDidCancle:Nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    [_passwrodTextField becomeFirstResponder];
    
    _passwrodTextField.hidden = YES;}

- (void)showNextView
{
//    CGPoint fromPnt = self.view.center;
//    CGPoint toPnt = CGPointMake(fromPnt.x - SCR_WIDTH, fromPnt.y);
//    CAAnimationGroup *animationGroup = [AnimationHelper showInputAccessoryBarFromPoint:fromPnt toPoint:toPnt duration:0.2];
//    [_contentView.layer addAnimation:animationGroup forKey:@"show"];
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.1 animations:^{
            _contentView.frame = CGRectMake(-self.width, 0, self.width, self.height);
            
        } completion:^(BOOL finished){
            _contentView.frame = CGRectMake(0, 0, self.width, self.height);
            [self resetAllStatus];
        }];
    });
   
}

- (void)resetAllStatus
{
    if(!_bRepeat)
    {
        _lblPrompt.text = NSLocalizedString(@"Enter the password protection", Nil);
    }
    else
    {
        _lblPrompt.text = NSLocalizedString(@"Please re-enter", Nil);
    }
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

    if (!_bRepeat) {
        _strPassword = text;
        _passwrodTextField.text = @"";
        _bRepeat = YES;
        [self showNextView];

    } else {
        if ([text isEqualToString:_strPassword]) {
            [BBUserDefault setProtectPasswrod:_strPassword];
            if ([self.passwordDelegate respondsToSelector:@selector(PasswordViewDidSetPassword:)]) {
                [self.passwordDelegate PasswordViewDidSetPassword:Nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            _lblMessage.text = NSLocalizedString(@"The passwords don't match", Nil);
            _bRepeat = NO;
            _passwrodTextField.text = @"";
            [self showNextView];

        }
    }
   
}

@end
