//
//  WYCurrentMonthView.m
//  PureChineseCalendar
//
//  Created by wangyangwork on 14-2-25.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYCurrentMonthView.h"
#import "DeviceCommon.h"

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
    
    
    NSDate *date = [NSDate date];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];

    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    
    
    
    
    
    
    for (NSUInteger i = 1; i <= days.length; i++) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-d"];
        NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d", year, month, i];
        NSDate *tempDate = [formatter dateFromString:dateString];
        
        NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
        NSDateComponents *tempDateComponents = [chineseCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:tempDate];
        
        NSString *dayString = [NSString stringWithFormat:@"%d", [tempDateComponents day]];
        float x = (i%7) * 30;
        float y = 20 * (i/7) + 100;
        CGPoint point = CGPointMake(x, y);
        [dayString drawAtPoint:point withAttributes:
         @{
           NSForegroundColorAttributeName: [UIColor colorWithRed:83.0/255 green:79.0/255 blue:78.0/255 alpha:1.0],
           NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13.0]}];
    }

}

- (void)lunarDateOfToday
{
  
    
}
@end
