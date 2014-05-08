//
//  WYMonthRow.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-5-6.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYMonthRow.h"
#import "WYLunarMap.h"

@implementation WYMonthRow

- (id)initWithStartDate:(WYDate *)date
{
    self = [super init];
    if (self) {
        _startDate = date;
        if (_startDate.day == 1) {
            // 要显示年月的
            self.bounds = CGRectMake(0, 0, 320, 68);
        }else{
            self.bounds = CGRectMake(0, 0, 320, 55);
        }
        self.backgroundColor = [UIColor redColor];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    WYDate *dateToDraw = _startDate;
    while (dateToDraw.month == _startDate.month) {
        
        
        float x = LEFT + (dateToDraw.weekday - 1) * WIDTH;
        
        float solarY = 0;
        
        NSString *solarDay = [NSString stringWithFormat:@"%lu", (unsigned long)dateToDraw.day];
        CGRect rect = CGRectMake(x, solarY, WIDTH, HEIGHT);
        [solarDay drawInRect:rect withAttributes:[WYLunarMap instance].weekDayFontAttributes];
        
        
        if (dateToDraw.day == 1) {
            // 显示年月
            
            NSString *yearMonth = [NSString stringWithFormat:@"%d年%d月", dateToDraw.year, dateToDraw.month];
            CGPoint point = CGPointMake(LEFT + 7, YEAR_MONTH_TOP);
            [yearMonth drawAtPoint:point withAttributes:[WYLunarMap instance].yearMonthFontAttributes];
            CGSize size = [yearMonth sizeWithAttributes:[WYLunarMap instance].yearMonthFontAttributes];
            
            
            CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);
            UIFont *font = [WYLunarMap instance].yearMonthFontAttributes[NSFontAttributeName];
            CGContextMoveToPoint(context, point.x, point.y + font.lineHeight + 2);
            CGContextAddLineToPoint(context, size.width + point.x, point.y + font.lineHeight + 2);
            CGContextStrokePath(context);
        }
        
        
        rect = CGRectMake(x, LUNAR_TOP, WIDTH, HEIGHT);
        if (dateToDraw.intLunarday == 1) {
            
            [dateToDraw.lunarMonth drawInRect:rect withAttributes:[WYLunarMap instance].lunarMonthFontAttributes];
        }else{
            [dateToDraw.lunarday drawInRect:rect withAttributes:[WYLunarMap instance].weekDayFontAttributes];
        }
        
        if (dateToDraw.weekday == 7) {
            break;
        }
        dateToDraw = [dateToDraw nextDate];
    }
    
}


@end
