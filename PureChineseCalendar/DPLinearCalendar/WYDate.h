//
//  WYDate.h
//  PureChineseCalendar
//
//  Created by wangyang on 14-5-1.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYDate : NSObject
@property (nonatomic, assign) NSUInteger year;
@property (nonatomic, assign) NSUInteger month;

//// 如果属性year与month与实际时间一样，isCurrentMonth则为YES
//@property (nonatomic, assign) BOOL isCurrentMonth;

- (id)initWithYear:(NSUInteger)year month:(NSUInteger)month;
- (WYDate *)dateByAddingMonths:(NSInteger)count;
+ (WYDate *)currentDate;
- (BOOL)isEqualToDate:(WYDate *)date;
@end
