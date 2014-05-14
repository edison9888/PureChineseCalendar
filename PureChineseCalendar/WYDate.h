//
//  WYDate.h
//  PureChineseCalendar
//
//  Created by wangyang on 14-5-1.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYDate : NSObject
@property (nonatomic, readonly) NSUInteger year;
@property (nonatomic, readonly) NSUInteger month;
@property (nonatomic, readonly) NSUInteger day;
@property (nonatomic, readonly) NSUInteger daysOfMonth;
//@property (nonatomic, readonly) NSString *lunarYear;
@property (nonatomic, readonly) NSString *lunarMonth;
@property (nonatomic, readonly) NSString *lunarday;
@property (nonatomic, readonly) NSUInteger weekday;

@property (nonatomic, readonly) NSUInteger intLunarMonth;
@property (nonatomic, readonly) NSUInteger intLunarday;


- (BOOL)isEqualToDate:(WYDate *)date;
- (id)initWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
+ (id)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
- (WYDate *)nextDate;
- (WYDate *)preDate;

- (WYDate *)dateWithOffsetDay:(double)days;
@end
