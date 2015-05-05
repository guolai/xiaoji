//
//  NSNumber+Sort.m
//  bbnote
//
//  Created by Apple on 13-5-13.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "NSNumber+Sort.h"
#import "NSDate+String.h"

@implementation NSNumber (Sort)

NSComparisonResult compareRecords(BBRecord *firstRecrd, BBRecord *secondRecrd, void *context)
{
    NSDate *firstDate = firstRecrd.create_date;
    NSDate *secDate = secondRecrd.create_date;
    float fValue1 = [firstDate getFloatNumOfYearMonthDay];
    float fValue2 = [secDate getFloatNumOfYearMonthDay];
    NSComparisonResult result = NSOrderedSame;
    if(fValue1 < fValue2)
    {
        result = NSOrderedDescending;
    }
    else if(fValue1 > fValue2)
    {
        result = NSOrderedAscending;
    }
    return  result;
}

NSComparisonResult compareImages(BBImage *firstRecrd, BBImage *secondRecrd, void *context)
{
    NSDate *firstDate = firstRecrd.create_date;
    NSDate *secDate = secondRecrd.create_date;
    float fValue1 = [firstDate getFloatNumOfYearMonthDay];
    float fValue2 = [secDate getFloatNumOfYearMonthDay];
    NSComparisonResult result = NSOrderedSame;
    if(fValue1 < fValue2)
    {
        result = NSOrderedDescending;
    }
    else if(fValue1 > fValue2)
    {
        result = NSOrderedAscending;
    }
    return  result;
}


NSComparisonResult compareAudios(BBAudio *firstRecrd, BBAudio *secondRecrd, void *context)
{
    NSDate *firstDate = firstRecrd.create_date;
    NSDate *secDate = secondRecrd.create_date;
    float fValue1 = [firstDate getFloatNumOfYearMonthDay];
    float fValue2 = [secDate getFloatNumOfYearMonthDay];
    NSComparisonResult result = NSOrderedSame;
    if(fValue1 < fValue2)
    {
        result = NSOrderedDescending;
    }
    else if(fValue1 > fValue2)
    {
        result = NSOrderedAscending;
    }
    return  result;
}
@end