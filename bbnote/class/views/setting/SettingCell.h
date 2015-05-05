//
//  SettingCell.h
//  M6s
//
//  Created by zhuhb on 13-4-4.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnBtnSwitchPressedDelegate <NSObject>
- (void)onBtnSwitchPressed:(NSDictionary *)dic;
@end

@interface SwitchBtnTableCell : UITableViewCell
{
    UISwitch *btnSwitch_;
    UILabel *lblType_;
    UILabel *lblBind_;
}
@property (nonatomic, retain) id<OnBtnSwitchPressedDelegate> btnDelegate;
@property (nonatomic, retain) UISwitch *btnSwitch;
@property (nonatomic, retain) UILabel *lblType;
@property (nonatomic, retain) UILabel *lblBind;
@end

@interface SetTextTableCell : UITableViewCell
{
    UILabel *lblName_;
    UILabel *lblText_;
}
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic,retain) UILabel *lblText;
@end



@protocol OnTextEnterDelegate <NSObject>
- (void)textDidEntered:(NSDictionary *)dic;
@end

@interface TextFeildCell : UITableViewCell<UITextFieldDelegate>
{
    UITextField *textFld_;
}
@property (nonatomic, assign) id<OnTextEnterDelegate> textdelegate;
- (void)setcurText:(NSString *)str;
- (void)setcurTextFieldEnabled:(BOOL)bvalue;
@end

@interface SelectCell : UITableViewCell
{
    UIImageView *checkImg_;
    UILabel *lblText_;
}

@property (nonatomic, retain)UIImageView *checkImg;
@property (nonatomic, retain)UILabel *lblText;
@end