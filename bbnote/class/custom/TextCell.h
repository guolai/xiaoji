//
//  TextCell.h
//  helpevernote
//
//  Created by bob on 4/12/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontImge.h"
@interface TextTableCell : UITableViewCell
{
    UILabel *lblName_;
    UILabel *lblText_;
}
@property (nonatomic, strong) FontImge *fontImg;
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic,retain) UILabel *lblText;
@property (nonatomic, retain)UIImageView *myaccessView;
//@property (nonatomic, strong)UIImageView *redCircleView;
@end



@interface PersonTextTableCell : UITableViewCell
{
    UILabel *lblName_;
    UILabel *lblText_;
}
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic,retain) UILabel *lblText;
@property (nonatomic, retain)UIImageView *myaccessView;
@end

@interface EvernoteTableCell : UITableViewCell
{
    UILabel *lblName_;
    UILabel *lblText_;
}
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic,retain) UILabel *lblText;
//@property (nonatomic, retain)UIImageView *myaccessView;
@end