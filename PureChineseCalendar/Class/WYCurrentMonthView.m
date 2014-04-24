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

#define LEFT            65
#define WEEK_TOP        90
#define WIDTH           35
#define HEIGHT          35

#define SOLAR_TOP       110
#define LUNAR_TOP      125
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
    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
    CGContextMoveToPoint(context, 40, 80);
    CGContextAddLineToPoint(context, 40, 300);
    CGContextStrokePath(context);


//    //NO.1画一条线
//
//    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
//    CGContextMoveToPoint(context, 20, 20);
//    CGContextAddLineToPoint(context, 200,20);
//    CGContextStrokePath(context);
//
//
//
//    CGContextSetLineWidth(context, 1.0);
//    CGContextSetRGBFillColor (context, 0.5, 0.5, 0.5, 0.5);
    
    // 通过系统的格里高历，再转为中国农历
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-d"];
    
    NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    NSDictionary *fontAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:83.0/255 green:79.0/255 blue:78.0/255 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13.0]};

    
    for (NSUInteger i = 0; i < 7; i++) {
        float x = LEFT + i * WIDTH;
        float y = WEEK_TOP ;
        CGPoint point = CGPointMake(x, y);
        [[WYLunarMap instance].weeks[i] drawAtPoint:point withAttributes:fontAttributes];
    }
    
    
    for (NSUInteger i = 1; i <= days.length; i++) {
        
        NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d", year, month, i];
        NSDate *tempDate = [formatter dateFromString:dateString];
        NSDateComponents *tempDateComponents = [chineseCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:tempDate];
        
        NSString *lunarDay = [WYLunarMap instance].arrayDay[[tempDateComponents day] - 1];
        
        
        float x = LEFT + (i%7) * WIDTH;
        float solarY = SOLAR_TOP + (i/7) * HEIGHT;
        NSString *solarDay = [NSString stringWithFormat:@"%d", i];
        [solarDay drawAtPoint:CGPointMake(x, solarY) withAttributes:fontAttributes];

        float lunarY = LUNAR_TOP + (i/7) * HEIGHT;
        [lunarDay drawAtPoint:CGPointMake(x, lunarY) withAttributes:fontAttributes];
    }

}

@end
