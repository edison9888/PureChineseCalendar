//
//  WYMonthRow.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-5-6.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYMonthRow.h"
#import "WYLunarMap.h"

#define LEFT            20
#define WIDTH           40
#define HEIGHT          40
#define YEAR_MONTH_TOP  3
@implementation WYMonthRow

- (id)initWithStartDate:(WYDate *)date
{
    self = [super init];
    if (self) {
        _startDate = date;
        if (_startDate.day == 1) {
            // 要显示年月的
            self.bounds = CGRectMake(0, 0, 320, 55);
        }else{
            self.bounds = CGRectMake(0, 0, 320, 40);
        }
        self.backgroundColor = [UIColor redColor];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat centerY = self.bounds.size.height - 20;
    
    WYDate *dateToDraw = _startDate;
    while (dateToDraw.month == _startDate.month) {
        
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
        CGRect rect = CGRectMake(x, centerY - 15, WIDTH, 15);
        [solarDay drawInRect:rect withAttributes:[WYLunarMap instance].weekDayFontAttributes];

        // 显示阴历日期。如果是阴历的1号，要显示阴历月份
        rect = CGRectMake(x, centerY, WIDTH, 15);
        if (dateToDraw.intLunarday == 1) {
            [dateToDraw.lunarMonth drawInRect:rect withAttributes:[WYLunarMap instance].lunarMonthFontAttributes];
        }else{
            [dateToDraw.lunarday drawInRect:rect withAttributes:[WYLunarMap instance].weekDayFontAttributes];
        }
        
        // 如果是今天，就画圈
        if ([dateToDraw isEqualToDate:[WYDate currentDate]]) {
            CGPoint point = CGPointMake(LEFT + (dateToDraw.weekday - 1) * WIDTH, self.bounds.size.height - HEIGHT);
            CGRect ellipseRect = CGRectMake(point.x, point.y, WIDTH, HEIGHT);
            
            // 画圈
            CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
            //    CGContextAddEllipseInRect(context, ellipseRect);
            CGContextSetRGBFillColor (context, 0.8, 0.8, 0.8, 0.4);
            CGContextFillEllipseInRect(context, ellipseRect);
            CGContextStrokePath(context);
        }
        
        // 已经画到周六，该结束了
        if (dateToDraw.weekday == 7) {
            break;
        }
        
        dateToDraw = [dateToDraw nextDate];
    }
    
}


@end
