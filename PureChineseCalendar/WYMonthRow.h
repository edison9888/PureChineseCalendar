//
//  WYMonthRow.h
//  PureChineseCalendar
//
//  Created by wangyang on 14-5-6.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYDate.h"

@interface WYMonthRow : UIView
@property (nonatomic, readonly, strong) WYDate *startDate;
@property (nonatomic, readonly, strong) WYDate *endDate;
- (id)initWithStartDate:(WYDate *)date;
@end
