//
//  WYWeekdayLabel.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-5-5.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYWeekdayLabel.h"
#import "WYLunarMap.h"

@implementation WYWeekdayLabel

- (void)drawRect:(CGRect)rect
{
    // 显示星期
    for (NSUInteger i = 0; i < 7; i++) {
        float x = LEFT + i * WIDTH;
        float y = 0;
        [[WYLunarMap instance].weeks[i] drawInRect:CGRectMake(x, y, WIDTH, rect.size.height)
                                    withAttributes:[WYLunarMap instance].weekDayFontAttributes];
    }

}


@end
