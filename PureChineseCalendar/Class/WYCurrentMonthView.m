//
//  WYCurrentMonthView.m
//  PureChineseCalendar
//
//  Created by wangyangwork on 14-2-25.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYCurrentMonthView.h"
#import "WYCalendarCalculater.h"

@implementation WYCurrentMonthView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lunarDateOfToday];
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
    
    
    //NO.1画一条线
     
     CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
     CGContextMoveToPoint(context, 20, 20);
     CGContextAddLineToPoint(context, 200,20);
     CGContextStrokePath(context);
    
    
    
    
    /*NO.2写文字
     
     CGContextSetLineWidth(context, 1.0);
     CGContextSetRGBFillColor (context, 0.5, 0.5, 0.5, 0.5);
     UIFont  *font = [UIFont boldSystemFontOfSize:18.0];
     [@"公司：北京中软科技股份有限公司\n部门：ERP事业部\n姓名：McLiang" drawInRect:CGRectMake(20, 40, 280, 300) withFont:font];
     */
    
}

- (void)lunarDateOfToday
{
    NSDictionary *lunarInfo = [[WYCalendarCalculater shareInstance] lunarOfToday];
    ///星期、月、日、阴历月、阴历日
    // 公历：比如得到今天是13号，往前数到1，往后数到这个月末。
    // 农历：比如得到初五，往前数
    NSString *solarDayString = lunarInfo[@"sDay"];
    
    int solarDayNumber = [solarDayString intValue];
    
    int leftOffset = solarDayNumber - 1;
    
    // 得到公历的这个月有多少天
    NSDate *today = [NSDate date]; //Get a date object for today's date
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:today];
    
    int rightOffset = days.length - solarDayNumber;
    
    // 使用这两个offset可以从lunarDays中取出对应的
    

    // 得到农历的这个月有多少天
    
}
@end
