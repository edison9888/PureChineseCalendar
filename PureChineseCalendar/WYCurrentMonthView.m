//
//  WYCurrentMonthView.m
//  PureChineseCalendar
//
//  Created by wangyangwork on 14-2-25.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYCurrentMonthView.h"
#import "WYLunarMap.h"
#import <CoreText/CoreText.h>
#import <mach/mach_time.h>


#define LEFT            20

#define WIDTH           40
#define HEIGHT          40

#define YEAR_MONTH_TOP  0
#define SOLAR_TOP       YEAR_MONTH_TOP + 18
#define LUNAR_TOP       (SOLAR_TOP + 20)
@interface WYCurrentMonthView ()
{
    BOOL isCurrentMonth;
}

@end

@implementation WYCurrentMonthView

- (id)initWithDate:(WYDate *)date isCurrentMonth:(BOOL)flag
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 315)];
    if (self) {
        _cellDate = date;
        isCurrentMonth = flag;
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

/*
 绘画参考：http://blog.csdn.net/zhibudefeng/article/details/8463268
 
 */

- (void)drawRect:(CGRect)rect
{
    uint64_t start = mach_absolute_time ();
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 通过系统的格里高历，再转为中国农历
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:_cellDate.month];
    [dateComponents setYear:_cellDate.year];
    
    NSDate *date = [[WYLunarMap instance].gregorianCalendar dateFromComponents:dateComponents];
    
    dateComponents = [[WYLunarMap instance].gregorianCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
    NSRange days = [[WYLunarMap instance].gregorianCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    

    
    // 显示月视图
    int step = 0;
    for (NSUInteger i = 1; i <= days.length; i++) {
        
        NSString *solarDateString = [NSString stringWithFormat:@"%ld-%ld-%lu", (long)_cellDate.year, (long)_cellDate.month, (unsigned long)i];
        NSDate *solarDate = [[WYLunarMap instance].formatter dateFromString:solarDateString];
        
        NSDateComponents *lunarDateComponents = [[WYLunarMap instance].chineseCalendar components:NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth fromDate:solarDate];
        NSUInteger weekday = [lunarDateComponents weekday];
        NSString *lunarDay = [WYLunarMap instance].arrayDay[[lunarDateComponents day] - 1];
        NSString *lunarMonth = [WYLunarMap instance].arrayMonth[[lunarDateComponents month] - 1];
        float x = LEFT + (weekday-1) * WIDTH;
        
        float solarY = SOLAR_TOP + step * HEIGHT;
        
        NSString *solarDay = [NSString stringWithFormat:@"%lu", (unsigned long)i];
        CGRect rect = CGRectMake(x, solarY, WIDTH, HEIGHT);
        [solarDay drawInRect:rect withAttributes:[WYLunarMap instance].weekDayFontAttributes];

        
        if (i == 1) {
            // 显示年月
            
            NSString *yearMonth = [NSString stringWithFormat:@"%lu年%lu月", (unsigned long)_cellDate.year, (unsigned long)_cellDate.month];
            CGPoint point = CGPointMake(LEFT + 7, YEAR_MONTH_TOP);
            [yearMonth drawAtPoint:point withAttributes:[WYLunarMap instance].yearMonthFontAttributes];
            CGSize size = [yearMonth sizeWithAttributes:[WYLunarMap instance].yearMonthFontAttributes];
            
            
            CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);
            UIFont *font = [WYLunarMap instance].yearMonthFontAttributes[NSFontAttributeName];
            CGContextMoveToPoint(context, point.x, point.y + font.lineHeight + 2);
            CGContextAddLineToPoint(context, size.width + point.x, point.y + font.lineHeight + 2);
            CGContextStrokePath(context);
        }
        
        
        
        float lunarY = LUNAR_TOP + step * HEIGHT;
        rect = CGRectMake(x, lunarY, WIDTH, HEIGHT);
        if ([lunarDateComponents day] == 1) {
            
            [lunarMonth drawInRect:rect withAttributes:[WYLunarMap instance].lunarMonthFontAttributes];
        }else{
            [lunarDay drawInRect:rect withAttributes:[WYLunarMap instance].weekDayFontAttributes];
        }
        
        
        if (weekday == 7) {
            step ++;
        }
    }
    
    // 显示这个月
    if (isCurrentMonth) {

        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:[NSDate date]];
        NSUInteger todayWeekday = [dateComponents weekday];
        
        
        CGPoint point = CGPointMake(LEFT + (todayWeekday - 1) * WIDTH, SOLAR_TOP + ([dateComponents weekOfMonth] - 1) * HEIGHT);
        CGRect ellipseRect = CGRectMake(point.x, point.y - 3, WIDTH, HEIGHT);
        
        // 画圈
        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
        //    CGContextAddEllipseInRect(context, ellipseRect);
        CGContextSetRGBFillColor (context, 0.8, 0.8, 0.8, 0.4);
        CGContextFillEllipseInRect(context, ellipseRect);
        CGContextStrokePath(context);
    }
    
    
    
    
    
    
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    uint64_t nanos = elapsed * info.numer / info.denom;
    NSLog(@"加载时间 %f", (CGFloat)nanos / NSEC_PER_SEC);

}
 
 

@end
