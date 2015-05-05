//
//  BBDateView.h
//  bbnote
//
//  Created by Apple on 13-4-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBDateViewDelegate;
@interface BBDateView : UIView
{
    @private
    int iMoodCount_;
    int iWeekWidth_;
    NSString *strVip_;
    CGPoint priPnt_;
    UIImageView *imgView1_;
    UIImageView *imgView2_;
    UIButton *btnMood_;
}
@property (nonatomic, assign) id<BBDateViewDelegate> delegate;
@property (nonatomic, retain) NSString *strDate;
@property (nonatomic, retain) NSString *strWeek;
@property (nonatomic, retain) NSString *strTime;
@property (nonatomic, retain) NSString *strColor;
@property (nonatomic, retain) NSString *strMood;
//@property (nonatomic, retain)
- (void)setDate:(NSDate *)date withColor:(NSString *)strcolor andMood:(NSNumber *)mood;
- (void)changeMood:(NSNumber *)mood;
- (int)getMoodCount;
//- (void)changeMoodCount:(int)iCount;
@end

@protocol BBDateViewDelegate <NSObject>
- (void)changeDateTime;
- (void)changeMood;
//- (void)changMoodCount;
@end
