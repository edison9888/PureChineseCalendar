//
//  WYMonthRow.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-5-6.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYMonthRow.h"
#import "WYLunarMap.h"
#import <mach/mach_time.h>


#define LEFT            20
#define WIDTH           40
#define HEIGHT          45
#define FIRST_HEIGHT    60
#define YEAR_MONTH_TOP  3

@interface WYMonthRow ()
{
    
}

@end

@implementation WYMonthRow

- (id)initWithStartDate:(WYDate *)date
{
    self = [super init];
    if (self) {
        
        self.startDate = date;
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setStartDate:(WYDate *)startDate
{
    _startDate = startDate;
    // 从startDate是星期几这个来决定endDate是相对startDate多了几天
    NSUInteger endDay = startDate.day + (7 - startDate.weekday);
    if (endDay <= _startDate.daysOfMonth) {
        _endDate = [[WYDate alloc] initWithYear:startDate.year month:startDate.month day:endDay];
    }else{
        _endDate = [[WYDate alloc] initWithYear:startDate.year month:startDate.month day:startDate.daysOfMonth];
    }
    
    if (_startDate.day == 1) {
        // 要显示年月的
        self.bounds = CGRectMake(0, 0, 320, FIRST_HEIGHT);
    }else{
        self.bounds = CGRectMake(0, 0, 320, HEIGHT);
    }
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat centerY = rect.size.height - 20;
    
    WYDate *dateToDraw = _startDate;
    
    while (YES) {
        
        // 如果是阳历1号，要显示年月
        if (dateToDraw.day == 1) {
            NSString *yearMonth = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)dateToDraw.year, (unsigned long)dateToDraw.month];
            CGPoint point = CGPointMake(LEFT + 7, YEAR_MONTH_TOP);
            [yearMonth drawAtPoint:point withAttributes:[WYLunarMap instance].yearMonthFontAttributes];
            CGSize size = [yearMonth sizeWithAttributes:[WYLunarMap instance].yearMonthFontAttributes];
            
            
            CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);
            UIFont *font = [WYLunarMap instance].yearMonthFontAttributes[NSFontAttributeName];
            CGContextMoveToPoint(context, point.x, point.y + font.lineHeight + 2);
            CGContextAddLineToPoint(context, size.width + point.x, point.y + font.lineHeight + 2);
            CGContextStrokePath(context);
        }
        
        // 显示阳历日期
        float x = LEFT + (dateToDraw.weekday - 1) * WIDTH;
        NSString *solarDay = [NSString stringWithFormat:@"%lu", (unsigned long)dateToDraw.day];
        CGRect tempRect = CGRectMake(x, centerY - 15, WIDTH, 15);
        [solarDay drawInRect:tempRect withAttributes:[WYLunarMap instance].weekDayFontAttributes];

        // 显示阴历日期。如果是阴历的1号，要显示阴历月份
        tempRect = CGRectMake(x, centerY, WIDTH, 15);
        if (dateToDraw.intLunarday == 1) {
            [dateToDraw.lunarMonth drawInRect:tempRect withAttributes:[WYLunarMap instance].lunarMonthFontAttributes];
        }else{
            [dateToDraw.lunarday drawInRect:tempRect withAttributes:[WYLunarMap instance].weekDayFontAttributes];
        }
        
        // 如果是今天，就画圈
        if ([dateToDraw isEqualToDate:[WYLunarMap instance].currentDate]) {
            CGPoint point = CGPointMake(LEFT + (dateToDraw.weekday - 1) * WIDTH, self.bounds.size.height - WIDTH);
            CGRect ellipseRect = CGRectMake(point.x, point.y, WIDTH, WIDTH);
            
            // 画圈
            CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
            //    CGContextAddEllipseInRect(context, ellipseRect);
            CGContextSetRGBFillColor (context, 0.8, 0.8, 0.8, 0.4);
            CGContextFillEllipseInRect(context, ellipseRect);
            CGContextStrokePath(context);
        }
        
        // 结束标志
        if (dateToDraw.day == _endDate.day) {
            break;
        }
        
        dateToDraw = [dateToDraw nextDate];
    }
}


@end
