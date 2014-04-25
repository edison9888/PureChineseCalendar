//
//  WYCurrentMonthView.m
//  PureChineseCalendar
//
//  Created by wangyangwork on 14-2-25.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYCurrentMonthView.h"
#import "DeviceCommon.h"
#import "WYLunarMap.h"

#define LEFT            40
#define WEEK_TOP        90
#define WIDTH           35
#define HEIGHT          40

#define SOLAR_TOP       (WEEK_TOP + 30)
#define LUNAR_TOP       (WEEK_TOP + 45)
@implementation WYCurrentMonthView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    
    return self;
}
/*
 绘画参考：http://blog.csdn.net/zhibudefeng/article/details/8463268
 
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
//    CGContextMoveToPoint(context, 40, 80);
//    CGContextAddLineToPoint(context, 40, 300);
//    CGContextStrokePath(context);


    
    // 通过系统的格里高历，再转为中国农历
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger today = [dateComponents day];
    NSUInteger todayWeekday = [dateComponents weekday];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-d"];
    
    NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    NSDictionary *fontAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:25.0/255 green:25.0/255 blue:25.0/255 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13.0]};

    for (NSUInteger i = 0; i < 7; i++) {
        float x = LEFT + i * WIDTH;
        float y = WEEK_TOP ;
        CGPoint point = CGPointMake(x, y);
        [[WYLunarMap instance].weeks[i] drawAtPoint:point withAttributes:fontAttributes];
    }
    
    int step = 0;
    for (NSUInteger i = 1; i <= days.length; i++) {
        
        NSString *solarDateString = [NSString stringWithFormat:@"%ld-%ld-%lu", (long)year, (long)month, (unsigned long)i];
        NSDate *solarDate = [formatter dateFromString:solarDateString];
        NSDateComponents *solarDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:solarDate];
        NSUInteger weekday = [solarDateComponents weekday];
        
        NSDateComponents *lunarDateComponents = [chineseCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:solarDate];
        
        NSString *lunarDay = [WYLunarMap instance].arrayDay[[lunarDateComponents day] - 1];
        
        float x = LEFT + (weekday-1) * WIDTH;
        
        float solarY = SOLAR_TOP + step * HEIGHT;
        
        NSString *solarDay = [NSString stringWithFormat:@"%lu", (unsigned long)i];
        [solarDay drawAtPoint:CGPointMake(x, solarY) withAttributes:fontAttributes];

        float lunarY = LUNAR_TOP + step * HEIGHT;
        [lunarDay drawAtPoint:CGPointMake(x, lunarY) withAttributes:fontAttributes];
        
        if (weekday == 7) {
            step ++;
        }
    }
    
    CGPoint point = CGPointMake(LEFT + (todayWeekday - 1) * WIDTH, LUNAR_TOP + (today/7) * HEIGHT);
    CGRect ellipseRect = CGRectMake(point.x - 10, point.y - 10, WIDTH, WIDTH);

    // 画圈
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
    CGContextAddEllipseInRect(context, ellipseRect);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBFillColor (context, 0.5, 0.5, 0.5, 0.5);
    CGContextStrokePath(context);
}

@end
