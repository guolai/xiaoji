//
//  DateViewController.m
//  BPM-iphone
//
//  Created by zhuhb on 12-11-8.
//  Copyright (c) 2012年 zhuhb. All rights reserved.
//

#import "DateViewController.h"
#import "BBSkin.h"
#import "BBUserDefault.h"
#import "NSDate+String.h"
#import "NSString+Help.h"


@interface DateViewController ()
@property (nonatomic, retain) NSString *strStartDate;
@property (nonatomic, retain) NSString *strStartTime;
@property (nonatomic, retain) UIDatePicker *datePicker;
- (void)changePickerDetail:(id)sender;
- (void)saveChange:(id)sender;
- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker;
@end

@implementation DateViewController
@synthesize strStartDate, strStartTime;
@synthesize datePicker;
@synthesize delegate;

- (void)loadView
{
    
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    
    float viewHeight = self.height;
    
    float fTop = 0;
    if(OS_VERSION < 7.0)
    {
        viewHeight -= self.navBarHeight;
        viewHeight -= 20;
    }
    else
    {
//        viewHeight -= self.navBarHeight;
        fTop += self.navBarHeight;
        fTop += 40;
    }
    
    float fWidth = 120;
    float fHeight = 30;
    float fSpace = 20;
    int iFontsize = 18;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        fTop += 20;
    }
    else
    {
        fTop = 200;
        fWidth = 200;
        fHeight = 60;
        fSpace = 40;
        iFontsize *= 2;
    }
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2 - fWidth, fTop, fWidth, fHeight)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl  setFont:[UIFont boldSystemFontOfSize:iFontsize]];
    [lbl setText:@"日期"];
    [self.view addSubview:lbl];
    btnStartDate_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnStartDate_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnStartDate_ setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btnStartDate_ addTarget:self action:@selector(changePickerDetail:) forControlEvents:UIControlEventTouchUpInside];
    [btnStartDate_ setFrame:CGRectMake(self.width / 2, fTop, fWidth, fHeight)];
    [btnStartDate_ setTitle:self.strStartDate forState:UIControlStateNormal];
    [btnStartDate_.titleLabel setFont:[UIFont systemFontOfSize:iFontsize]];
    [btnStartDate_ setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:btnStartDate_];
    fTop += fHeight;
    fTop += fSpace;
    
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2 - fWidth, fTop, fWidth, fHeight)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont boldSystemFontOfSize:iFontsize]];
    [lbl setText:@"时间"];
    [self.view addSubview:lbl];
    btnStartTime_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnStartTime_  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnStartTime_ setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btnStartTime_ addTarget:self action:@selector(changePickerDetail:) forControlEvents:UIControlEventTouchUpInside];
    [btnStartTime_ setFrame:CGRectMake(self.width / 2, fTop, fWidth, fHeight)];
    [btnStartTime_ setTitle:self.strStartTime forState:UIControlStateNormal];
    [btnStartTime_ setBackgroundColor:[UIColor whiteColor]];
    [btnStartTime_.titleLabel setFont:[UIFont systemFontOfSize:iFontsize]];
    [self.view addSubview:btnStartTime_];
    fTop += fHeight;
    fTop += fSpace;
    
    
    fTop += fHeight;
    fTop += fSpace;
    
    fTop += fHeight;
    fTop += fSpace - 10;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, viewHeight - 216, self.width, 216)];
    }
    else
    {
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, viewHeight - fTop - 160, self.width, 600)];
    }
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    if(OS_VERSION >= 7.0)
        [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.datePicker];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
    }
    else
    {
        int iHeight = self.datePicker.frame.size.height;
        [self.datePicker setFrame:CGRectMake(0, viewHeight - iHeight, self.width, iHeight)];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate* minDate = [df dateFromString:@"1990-01-01 00:00"];
    NSDate* maxDate = [df dateFromString:@"2150-01-01 00:00"];
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = maxDate;
    
    [self.datePicker addTarget:self
                        action:@selector(datePickerDateChanged:)
              forControlEvents:UIControlEventValueChanged];
    iCurrentBtn_  = 1;
    BBINFO(@"%@", [NSString stringWithFormat:@"%@ %@",self.strStartDate, self.strStartTime]);
    NSDate* curDate = [df dateFromString:[NSString stringWithFormat:@"%@ %@",self.strStartDate, self.strStartTime]];
    self.datePicker.date = curDate;
	// Do any additional setup after loading the view.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self showBackButton:NSLocalizedString(@"Back", nil) andTitle:@"选择日期"];
    [self showLeftButton:NSLocalizedString(@"Cancle", nil) withImage:nil highlightImge:nil andEvent:@selector(backPressed:)];
    [self showTitle:@"选择日期"];
    [self showRigthButton:NSLocalizedString(@"OK", nil) withImage:nil highlightImge:nil andEvent:@selector(saveChange:)];
}

- (void)setDate:(NSDate *)date
{
    if(_date != date)
    {
        _date = date;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *strCurentDate = [dateFormater stringFromDate:date];
        NSArray *array = [strCurentDate componentsSeparatedByString:@"-"];
        if(array.count != 6)
        {
            NSLog(@"datePickerDateChanged get date failed ");
            return;
        }
        
        NSString *strStartDate1 = [NSString stringWithFormat:@"%@%@%@", [array objectAtIndex:0], [array objectAtIndex:1], [array objectAtIndex:2]];
        NSString *strStartTime1 = [NSString stringWithFormat:@"%@%@", [array objectAtIndex:3], [array objectAtIndex:4]];
        self.strStartDate = [strStartDate1 getDate];
        self.strStartTime = [strStartTime1 getTime];
    }
}

- (void)backBtnPressed:(id)sener
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)changePickerDetail:(id)sender
{
    [btnStartDate_  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnStartDate_ setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btnStartTime_  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnStartTime_ setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    
    [(UIButton *)sender  setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [(UIButton *)sender setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    

    if(sender == btnStartDate_)
    {
        iCurrentBtn_ = 1;
         self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.date = [self getSelectedDate];
    }
    else if(sender == btnStartTime_)
    {
        iCurrentBtn_ = 2;
         self.datePicker.datePickerMode = UIDatePickerModeTime;
     
        self.datePicker.date = [self getSelectedDate];
    }

}

- (NSDate *)getSelectedDate
{
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    df2.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate* curDate = [df2 dateFromString:[NSString stringWithFormat:@"%@ %@",self.strStartDate, self.strStartTime]];
    return curDate;
}

- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{
    
    if ([paramDatePicker isEqual:self.datePicker])
    {
        //BBLOG();
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *strCurentDate = [dateFormater stringFromDate:paramDatePicker.date];
        NSArray *array = [strCurentDate componentsSeparatedByString:@"-"];
        if(array.count != 6)
        {
            NSLog(@"datePickerDateChanged get date failed ");
            return;
        }
        if(iCurrentBtn_ == 1)
        {
 
            self.strStartDate = [NSString stringWithFormat:@"%@-%@-%@", [array objectAtIndex:0], [array objectAtIndex:1], [array objectAtIndex:2]];
            [btnStartDate_ setTitle:self.strStartDate forState:UIControlStateNormal];
        }
        else if(iCurrentBtn_ == 2)
        {
 
            self.strStartTime = [NSString stringWithFormat:@"%@:%@", [array objectAtIndex:3], [array objectAtIndex:4]];
            [btnStartTime_ setTitle:self.strStartTime forState:UIControlStateNormal];
        }
    }
    
}

- (void)backPressed:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(presentViewCtrDidCancel:)])
    {
        [self.delegate presentViewCtrDidCancel:nil];
    }
}

- (void)saveChange:(id)sender
{
    self.date = [self getSelectedDate];
    if(self.delegate && [self.delegate respondsToSelector:@selector(presentViewCtrDidFinish:)])
    {
        [self.delegate presentViewCtrDidFinish:self];
    }
}
@end
