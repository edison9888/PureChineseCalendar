//
//  WYDate.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-5-1.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYDate.h"

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
- (WYDate *)dateByAddingMonths:(NSInteger)count
{
    // 当前月在追加或者减少一定数量的月份，年份很有可能发生变化。其中的数学关系还算简单。
//    NSInteger i = _month + count;
//    if (i < -12) {
//        NSInteger month = (i) % 12 + 12;
//        NSInteger year = _year + (i / 12);
//        return [[WYDate alloc] initWithYear:year month:month];
//    }else if (i >= -12 && i <= 0){
//        NSInteger month = 12 + i;
//        NSInteger year = _year - 1;
//        return [[WYDate alloc] initWithYear:year month:month];
//    }else{
//        NSInteger month = i % 12;
//        if (month == 0) {
//            month = 12;
//        }
//        NSInteger year = _year + i/12;
//        return [[WYDate alloc] initWithYear:year month:month];
//    }

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
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    WYDate *date = [[WYDate alloc] initWithYear:[dateComponents year] month:[dateComponents month]];
    return date;

}

- (BOOL)isEqualToDate:(WYDate *)date
{
    if (_year == date.year && _month == date.month) {
        return YES;
    }else{
        return NO;
    }
}
@end
