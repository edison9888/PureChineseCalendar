//
//  WYCurrentMonthView.h
//  PureChineseCalendar
//
//  Created by wangyangwork on 14-2-25.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYCurrentMonthView : UIView
/**
 *  实例化一个 WYCurrentMonthView。
 *
 *  @param year  月历所在的年。公历年
 *  @param month 要显示的月历。公历月
 *  @param flag  要显示的月历是否是当前时间所在月
 *
 *  @return 实例化对象
 */
- (id)initWithYear:(NSUInteger)year month:(NSUInteger)month isCurrentMonth:(BOOL)flag;
@end
