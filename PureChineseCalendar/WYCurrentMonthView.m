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
#import <CoreText/CoreText.h>

#define LEFT            21
#define WEEK_TOP        30
#define WIDTH           40
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
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    NSDictionary *fontAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:25.0/255 green:25.0/255 blue:25.0/255 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13.0], NSParagraphStyleAttributeName:style};
    // 显示星期
    for (NSUInteger i = 0; i < 7; i++) {
        float x = LEFT + i * WIDTH;
        float y = WEEK_TOP ;
        CGRect rect = CGRectMake(x, y, WIDTH, HEIGHT);
        [[WYLunarMap instance].weeks[i] drawInRect:rect withAttributes:fontAttributes];
    }
    
    
//    year = 2012;
//    month = 8;
    int step = 0;
    for (NSUInteger i = 1; i <= days.length; i++) {
        
        NSString *solarDateString = [NSString stringWithFormat:@"%ld-%ld-%lu", (long)year, (long)month, (unsigned long)i];
        NSDate *solarDate = [formatter dateFromString:solarDateString];
        
        NSDateComponents *lunarDateComponents = [chineseCalendar components:NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth fromDate:solarDate];
        NSUInteger weekday = [lunarDateComponents weekday];
        NSString *lunarDay = [WYLunarMap instance].arrayDay[[lunarDateComponents day] - 1];
        NSString *lunarMonth = [WYLunarMap instance].arrayMonth[[lunarDateComponents month] - 1];
        float x = LEFT + (weekday-1) * WIDTH;
        
        float solarY = SOLAR_TOP + step * HEIGHT;
        
        NSString *solarDay = [NSString stringWithFormat:@"%lu", (unsigned long)i];
        CGRect rect = CGRectMake(x, solarY, WIDTH, HEIGHT);
        [solarDay drawInRect:rect withAttributes:fontAttributes];

        float lunarY = LUNAR_TOP + step * HEIGHT;
        rect = CGRectMake(x, lunarY, WIDTH, HEIGHT);
        if ([lunarDateComponents day] == 1) {
            [lunarMonth drawInRect:rect withAttributes:fontAttributes];
        }else{
            [lunarDay drawInRect:rect withAttributes:fontAttributes];
        }
        
        
        if (weekday == 7) {
            step ++;
        }
    }
    
    CGPoint point = CGPointMake(LEFT + (todayWeekday - 1) * WIDTH, SOLAR_TOP + (today/7) * HEIGHT);
    CGRect ellipseRect = CGRectMake(point.x, point.y - 3, WIDTH, HEIGHT);

    // 画圈
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
//    CGContextAddEllipseInRect(context, ellipseRect);
    CGContextSetRGBFillColor (context, 0.8, 0.8, 0.8, 0.4);
    CGContextFillEllipseInRect(context, ellipseRect);
    CGContextStrokePath(context);
    
    
    
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    CGMutablePathRef path = CGPathCreateMutable(); //1
//    CGPathAddRect(path, NULL, self.bounds );
//    NSAttributedString* attString = [[NSAttributedString alloc]
//                                      initWithString:@"Hello core text world!"]; //2
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString); //3
//    CTFrameRef frame =
//    CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
//    CTFrameDraw(frame, context); //4
//    
//
//    
//    CFRelease(frame); //5
//    CFRelease(path);
//    CFRelease(framesetter);
}

@end
