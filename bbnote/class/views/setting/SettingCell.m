//
//  SettingCell.m
//  M6s
//
//  Created by zhuhb on 13-4-4.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "SettingCell.h"
#include "Constant.h"
#import "BBSkin.h"

@implementation SwitchBtnTableCell
@synthesize lblBind = lblBind_;
@synthesize lblType = lblType_;
@synthesize btnSwitch = btnSwitch_;
@synthesize btnDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //int iHeight = 30;
        int iLblWidth = 140;
        int iSpace = 20;
        int iTotalWidth = [BBAutoSize screenWidth] - 40;
        int iFontSize = 16 * fScr_Scale;
        int iTopsapce = 8;
        lblType_ = [[UILabel alloc] initWithFrame:CGRectMake(iSpace, iTopsapce + 2, iLblWidth, iFontSize + 2)];
        [lblType_ setFont:[UIFont boldSystemFontOfSize:iFontSize]];
        [lblType_ setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblType_];
        
        lblBind_ = [[UILabel alloc] initWithFrame:CGRectMake(iTotalWidth + iSpace - iLblWidth - 60, iTopsapce + 2, 60, iFontSize + 2)];
        [lblBind_ setFont:[UIFont boldSystemFontOfSize:iFontSize]];
        [lblBind_ setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblBind_];
        lblBind_.hidden = YES;
        btnSwitch_ = [[UISwitch alloc] initWithFrame:CGRectMake(iTotalWidth + iSpace - iLblWidth + 50, iTopsapce , 60, 20)];
        [self addSubview:btnSwitch_];
        btnSwitch_.onTintColor = [BBSkin shareSkin].titleBgColor;
        [btnSwitch_ addTarget:self action:@selector(btnSwitchPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnSwitchPressed:(id)sender
{
    NSMutableDictionary *dic;
    if(btnSwitch_.on)
    {
        //btnSwitch_.on = NO;
        dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lblType_.text, @"name", @"YES", @"state", nil];
    }
    else
    {
        //btnSwitch_.on = YES;
        dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lblType_.text, @"name", @"NO", @"state", nil];
    }
    if(self.btnDelegate && [self.btnDelegate respondsToSelector:@selector(onBtnSwitchPressed:)])
    {
        [self.btnDelegate onBtnSwitchPressed:dic];
    }
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    // Configure the view for the selected state
//}
@end

@implementation SetTextTableCell
@synthesize lblName = lblName_;
@synthesize lblText = lblText_;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //  int iHeight = 30;
        int iLblWidth = 200;
        int iTotalWidht = [BBAutoSize screenWidth] - 40;
        int iSpace = 20;
        int iFontSize = 16 * fScr_Scale;
        int iTopsapce = 12;
        lblName_ = [[UILabel alloc] initWithFrame:CGRectMake(iSpace, iTopsapce, iLblWidth, iFontSize)];
        [lblName_ setFont:[UIFont boldSystemFontOfSize:iFontSize]];
        [lblName_ setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblName_];
        
        lblText_ = [[UILabel alloc] initWithFrame:CGRectMake(iLblWidth + iSpace, iTopsapce, iTotalWidht - iLblWidth - iSpace,iFontSize)];
        [lblText_ setTextAlignment:NSTextAlignmentRight];
        [lblText_ setFont:[UIFont systemFontOfSize:iFontSize - 2]];
        [lblText_ setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblText_];
        UIImage *img = [UIImage imageNamed:@"setting_access.png"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(iTotalWidht, iTopsapce, img.size.width, img.size.height)];
        [imgView setImage:img];
        [self addSubview:imgView];
    }
    return self;
}
@end


@implementation TextFeildCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIFont *font = [UIFont systemFontOfSize:INPUT_FONT_SIZE];
        textFld_ = [[UITextField alloc]  init];
        textFld_.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFld_.font = font;
        textFld_.delegate = self;
        textFld_.returnKeyType = UIReturnKeyDone;
        [textFld_ setBackgroundColor:[UIColor clearColor]];
        [textFld_ setFrame:CGRectMake(20, 10, SCR_WIDTH - 40, 30)];
        [self addSubview:textFld_];
    }
    return  self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual: textFld_])
    {
        [textFld_ resignFirstResponder];
        if(self.textdelegate && [self.textdelegate respondsToSelector:@selector(textDidEntered:)])
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.tag - CELL_TAG], @"tag", textField.text, @"text", nil];
            [self.textdelegate textDidEntered:dic];
        }
        return NO;
    }
    return YES;
}

- (void)setcurTextFieldEnabled:(BOOL)bvalue
{
    [textFld_ setEnabled:bvalue];
}

- (void)setcurText:(NSString *)str
{
    textFld_.text = str;
}
@end



@implementation SelectCell
@synthesize checkImg = checkImg_;
@synthesize lblText = lblText_;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //        bgImge_ = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, SCR_WIDTH - 12, 45)];
        //        [bgImge_ setImage:[UIImage imageNamed:@"qzsettingtop.png"]];
        //        [self addSubview:bgImge_];
        
        lblText_ = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, [BBAutoSize screenWidth] - 60, 24)];
        [lblText_ setBackgroundColor:[UIColor clearColor]];
        [lblText_ setFont:[UIFont systemFontOfSize:14]];
        [lblText_ setTextColor:[UIColor colorWithRed:88/255.0 green:26/255.0 blue:58/255.0 alpha:1.0]];
        [self addSubview:lblText_];
        
        checkImg_ = [[UIImageView alloc] initWithFrame:CGRectMake([BBAutoSize screenWidth] - 50, 10, 25, 25)];
        [checkImg_ setImage:[UIImage imageNamed:@"skin_check.png"]];
        [self addSubview:checkImg_];
        //[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}



@end
