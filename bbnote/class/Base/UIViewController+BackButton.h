//
//  UIViewController+BackButton.h
//  M6s
//
//  Created by zhuhb on 13-4-1.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    e_Nav_Defaut,
    e_Nav_Green,
    e_Nav_Gray,
    e_Nav_White
}T_Nav_Style;

@interface UIViewController (BackButton)
- (void)showBackButton:(NSString *)strBack action:(SEL)action;
- (void)showLeftButton:(NSString *)strTitle withImage:(NSString *)strImg highlightImge:(NSString *)strHlImg  andEvent:(SEL)action;
- (void)showRigthButton:(NSString *)strTitle withImage:(NSString *)strImg highlightImge:(NSString *)strHlImg   andEvent:(SEL)action;
- (void)showRigthButton:(NSString *)strTitle withTopImage:(NSString *)strImg tophighlightImge:(NSString *)strHlImg andEvent:(SEL)action;
- (void)showTitle:(NSString *)strTitle;
- (void)showBrowsePicture:(NSString *)strOrder andMonthDay:(NSString *)strTime andWeek:(NSString *)strWeek;
@end
