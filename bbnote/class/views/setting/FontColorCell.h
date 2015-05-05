//
//  FontColorCell.h
//  bbnote
//
//  Created by bob on 7/5/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectView.h"

@interface FontColorCell : UITableViewCell<SelectImageDelegate>
{
    NSMutableArray *arrayColors_;
    SelectView *selctView_;
}
@end
@interface FontBGColorCell: UITableViewCell<SelectImageDelegate>
{
    NSMutableArray *arrayColors_;
    SelectView *selctView_;
}
@end

