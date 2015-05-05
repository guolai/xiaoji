//
//  NSDate+String.m
//  Zine
//
//  Created by bob on 9/21/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import "NSDate+String.h"
#import "BBUserDefault.h"

@implementation NSDate (String)

- (NSString *)qzgetYearDate
{
    NSString *strValue;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    df.dateFormat = @"yyyy/MM/dd";
    strValue = [df stringFromDate:self];
    return  strValue;
}

- (int) qzgetYear
{
    NSString *strValue;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    df.dateFormat = @"yyyy/MM/dd";
    strValue = [df stringFromDate:self];
    
    NSArray *array = [strValue componentsSeparatedByString:@"/"];
    int iYear = [[array objectAtIndex:0] integerValue];
    return iYear;
}

- (NSString *)qzgetDateFormat
{
    NSString *strValue;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    strValue = [df stringFromDate:self];

    return  strValue;
}

- (NSString *)qzgetDateTime
{
    NSString *strValue;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
//    BBINFO(@"%@--%@", [[NSTimeZone defaultTimeZone] debugDescription], [[NSTimeZone systemTimeZone] debugDescription]);
//    [df setLocale:[NSLocale systemLocale]];
//    [df setLocale:[NSLocale localeWithLocaleIdentifier:@"GMT"]];
//    BBINFO(@"%@--%@", [[NSLocale systemLocale] debugDescription], [[NSLocale localeWithLocaleIdentifier:@"GMT"] debugDescription]);
    df.dateFormat = @"yyyyMMdd-HHmmss";
    strValue = [df stringFromDate:self];

    return  strValue;
}

//for note
- (NSString *)qzGetDate // 今天，昨天，前天，05/01
{
    NSString *strDate = [self qzgetDateTime];
    NSArray *array1 = [strDate componentsSeparatedByString:@"-"];
    NSString *strValue = [self qzgetYearDate];
    int iMonthDay = [[array1 objectAtIndex:0] integerValue];
    //int iHourMin = [[[array1 objectAtIndex:1] substringToIndex:4] integerValue];
    
    NSString *strCurDate = [[NSDate date] qzgetDateTime];
    NSArray *curArray = [strCurDate componentsSeparatedByString:@"-"];
    if(curArray.count == 2)
    {
        int iCurMonthDay = [[curArray objectAtIndex:0] integerValue];
        //int iCurHourMin = [[[curArray objectAtIndex:1] substringToIndex:4] integerValue];
        if(iCurMonthDay - iMonthDay == 1)
        {
            strValue = NSLocalizedString(@"Yesterday", nil);
        }
        else if(iCurMonthDay - iMonthDay == 0)
        {
                strValue = NSLocalizedString(@"Today", nil);
        }
        else
        {
            NSRange range = NSMakeRange(5, 5);
            if(strValue.length >= 10)
                strValue = [strValue substringWithRange:range];
        }
    }
    else
        return strValue;
    
    return strValue;
}

- (NSString *)qzGetWeek  //周一，。。。
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:self];
    [comps setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger week = [comps weekday];
    NSString *strWeek = @"星期一";
    if(week == 1)
    {
        strWeek = @"星期天";
    }
    else  if(week == 2)
    {
        strWeek = @"星期一";
    }
    else  if(week == 3)
    {
        strWeek = @"星期二";
    }
    else  if(week == 4)
    {
        strWeek = @"星期三";
    }
    else  if(week == 5)
    {
        strWeek = @"星期四";
    }
    else  if(week == 6)
    {
        strWeek = @"星期五";
    }
    else  if(week == 7)
    {
        strWeek = @"星期六";
    }
    return strWeek;
}

- (NSArray *)getWeekDays//返回本周的至今天的日期字符串
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:self];
    [comps setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger week = [comps weekday];
    NSUInteger nDay = [self getIntNumOfYearMonthDay];
    NSMutableArray *mulArray = [NSMutableArray arrayWithCapacity:week];
    for (int i = 0 ; i < week; i++) {
        NSString *strDay = [NSString stringWithFormat:@"%lu", nDay];
        [mulArray addObject:strDay];
        nDay--;
    }
    return mulArray;
}


- (NSString *)qzGetTime // 12:00
{
    NSString *strValue = [self qzgetDateFormat];
    BBINFO(@"==========  %@, %d", strValue, strValue.length);
    NSRange range = NSMakeRange(11, 5);
    strValue = [strValue substringWithRange:range];
    return strValue;
}

- (NSString *)getNumOfMonthDay //0715
{
    NSString *strValue;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    df.dateFormat = @"MMdd";
    strValue = [df stringFromDate:self];
    
    return  strValue;
}

- (NSString *)getNumOfYearMonth //201307
{
    NSString *strValue;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    df.dateFormat = @"yyyyMM";
    strValue = [df stringFromDate:self];

    return  strValue;
}

- (NSString *)getMonthDay //08/28
{
    NSString *strValue;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];

    // 时间日期的本地化稍微有些不同，需要先获取用户当前的语言，然后再初始化日期的格式就可以
    // MMM在英文中是月份的三个字母缩写，在中文是阿拉伯数字+月； MMMM在英文中是单词全称，在中文是大写数字＋月
    NSString *curLang = [[NSLocale preferredLanguages] objectAtIndex:0];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:curLang];
    df.dateFormat = NSLocalizedString(@"MM/dd", nil);

    strValue = [df stringFromDate:self];

    return  strValue;
}

- (NSString *)getStringOfYearMonthDay //20130705
{
    NSString *strValue;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    df.dateFormat = @"yyyyMMdd";
    strValue = [df stringFromDate:self];
    return strValue;
}

- (NSUInteger)getIntNumOfYearMonthDay //20130705
{
    NSString *strValue;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    df.dateFormat = @"yyyyMMdd";
    strValue = [df stringFromDate:self];
    NSUInteger fValue = [strValue integerValue];
    return  fValue;
}

- (NSUInteger)getFloatNumOfYearMonthDay //20130705
{
    NSString *strValue;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    df.dateFormat = @"yyyyMMddHHmmss";
    strValue = [df stringFromDate:self];
    float fValue = [strValue floatValue];
    return  fValue;
}

//+ (NSDate *)getCurDate
//{
//    NSDate *date = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
//    return localeDate;
//}

+ (NSDate *)getNoteBirthDay
{
    NSString *str = [BBUserDefault getTheTimeOfFirstUseApp];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];
    df.dateFormat = @"yyyy/MM/dd";
    NSDate *date = [df dateFromString:str];
    return date;
}


@end


