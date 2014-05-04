//
//  WYCurrentMonthView.h
//  PureChineseCalendar
//
//  Created by wangyangwork on 14-2-25.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYDate.h"

@interface WYCurrentMonthView : UIView
/**
 *  实例化一个 WYCurrentMonthView。
 *
 *  @param date     要显示的年月
 *  @param flag     要显示的月历是否是当前时间所在月
 *
 *  @return 实例化对象
 */
- (id)initWithDate:(WYDate *)date isCurrentMonth:(BOOL)flag;



@property (nonatomic,strong, readonly) WYDate *cellDate;

@end
