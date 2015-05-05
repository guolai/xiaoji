//
//  HomeViewController.h
//  jyy
//
//  Created by bob on 1/6/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BBViewController.h"


@interface HomeObject : NSObject

@property (nonatomic, assign)NSUInteger nTotoal;
@property (nonatomic, assign)NSUInteger nDayCount;
@property (nonatomic, assign)NSUInteger nTheWeekCount;
@property (nonatomic, assign)NSUInteger nTheDayCount;
@property (nonatomic, assign)NSUInteger nPhotosCount;
@property (nonatomic, assign)NSUInteger nTagCount;
//@property (nonatomic, assign)NSUInteger nCalendarCount;
@property (nonatomic, assign)NSUInteger nStarCount;
//@property (nonatomic, )

@end


@interface HomeViewController : BBViewController
{
    BOOL _bFirstIn;
}

@end
