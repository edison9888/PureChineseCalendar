//
//  WYDate.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-5-1.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYDate.h"
#import "WYLunarMap.h"
@interface WYDate ()
{
    NSDate *solarDate;
}

@end


@implementation WYDate
- (id)initWithYear:(NSUInteger)year month:(NSUInteger)month
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _year = year;
    _month = month;
    return self;
}

- (id)initWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    self = [super init];
    if (self) {
        _year = year;
        _month = month;
        _day = day;
        
        NSString *solarDateString = [NSString stringWithFormat:@"%ld-%ld-%lu", (long)year, (long)month, (long)day];
        solarDate = [[WYLunarMap instance].formatter dateFromString:solarDateString];
        
        NSRange range = [[WYLunarMap instance].gregorianCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:solarDate];
        _daysOfMonth = range.length;
        
        // 计算阴历日期
        NSDateComponents *lunarDateComponents = [[WYLunarMap instance].chineseCalendar components:NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth fromDate:solarDate];
        _weekday = [lunarDateComponents weekday];
        
        _intLunarday = [lunarDateComponents day];
        _intLunarMonth = [lunarDateComponents month];
        
        _lunarday = [WYLunarMap instance].arrayDay[_intLunarday - 1];
        _lunarMonth = [WYLunarMap instance].arrayMonth[_intLunarMonth - 1];
        
    }
    return self;
}

+ (id)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    WYDate *date = [[WYDate alloc] initWithYear:year month:month day:day];
    return date;
}

- (WYDate *)dateByAddingMonths:(NSInteger)count
{

    // _month是在1~12取值，count只会是1与-1，所以，mouth的取值范围是0~13
    NSInteger month = _month + count;
    if (month == 0) {
        return [[WYDate alloc] initWithYear:_year -1 month:12];
    }else if (month >= 1 && month <= 12){
        return [[WYDate alloc] initWithYear:_year month:month];
    }else{  // month == 13
        return [[WYDate alloc] initWithYear:_year + 1 month:1];
    }
}

+ (WYDate *)currentDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    WYDate *date = [WYDate dateWithYear:[dateComponents year] month:[dateComponents month] day:[dateComponents day]];
    return date;
}

+ (WYDate *)dateWithNSDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return [[WYDate alloc] initWithYear:[dateComponents year] month:[dateComponents month] day:[dateComponents day]];

}

- (BOOL)isEqualToDate:(WYDate *)date
{
    if (_year == date.year && _month == date.month && _day == date.day) {
        return YES;
    }else{
        return NO;
    }
}


- (WYDate *)nextDate
{
    NSDate *nextSolarDate = [solarDate dateByAddingTimeInterval:(24 * 3600)];
    return [WYDate dateWithNSDate:nextSolarDate];
}
- (WYDate *)preDate
{
    NSDate *preSolarDate = [solarDate dateByAddingTimeInterval:-(24 * 3600)];
    return [WYDate dateWithNSDate:preSolarDate];
}

- (WYDate *)dateWithOffsetDay:(double)days
{
    NSDate *nextSolarDate = [solarDate dateByAddingTimeInterval:(days * 24 * 3600)];
    return [WYDate dateWithNSDate:nextSolarDate];
}
@end
