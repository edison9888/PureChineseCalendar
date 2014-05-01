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
#define WEEK_TOP        20
#define WIDTH           40
#define HEIGHT          40

#define SOLAR_TOP       (WEEK_TOP + 45)
#define LUNAR_TOP       (WEEK_TOP + 60)
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
    CGContextRef context = UIGraphicsGetCurrentContext();


    
    // 通过系统的格里高历，再转为中国农历
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:_cellDate.month];
    [dateComponents setYear:_cellDate.year];
    
    NSDate *date = [calendar dateFromComponents:dateComponents];
    
    dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    
    
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
    
    // 显示月视图
    int step = 0;
    for (NSUInteger i = 1; i <= days.length; i++) {
        
        NSString *solarDateString = [NSString stringWithFormat:@"%ld-%ld-%lu", (long)_cellDate.year, (long)_cellDate.month, (unsigned long)i];
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

        
        if (i == 1) {
            // 显示年月
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
            UIColor *color = [UIColor colorWithRed:25.0/255 green:25.0/255 blue:25.0/255 alpha:1.0];
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSTextAlignmentLeft];
            NSDictionary *attributes = @{NSForegroundColorAttributeName : color,
                                         NSFontAttributeName:font,
                                         NSParagraphStyleAttributeName:style};
            NSString *yearMonth = [NSString stringWithFormat:@"%d年%d月", _cellDate.year, _cellDate.month];
            CGPoint point = CGPointMake(LEFT + 7, WEEK_TOP + 24);
//            CGRect yearMonthRect = CGRectMake(point.x, point.y, 90-point.x, font.lineHeight);
//            [yearMonth drawInRect:yearMonthRect withAttributes:attributes];
            [yearMonth drawAtPoint:point withAttributes:attributes];
            
            CGSize size = [yearMonth sizeWithAttributes:attributes];
            
            
            CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);
            CGContextMoveToPoint(context, point.x, point.y + font.lineHeight + 2);
            CGContextAddLineToPoint(context, size.width + point.x, point.y + font.lineHeight + 2);
            CGContextStrokePath(context);
        }
        
        
        
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
    
    
    
    
    // 显示这个月
    if (isCurrentMonth) {

        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:[NSDate date]];

        NSInteger today = [dateComponents day];
        NSUInteger todayWeekday = [dateComponents weekday];
        
        
        CGPoint point = CGPointMake(LEFT + (todayWeekday - 1) * WIDTH, SOLAR_TOP + (today/7) * HEIGHT);
        CGRect ellipseRect = CGRectMake(point.x, point.y - 3, WIDTH, HEIGHT);
        
        // 画圈
        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
        //    CGContextAddEllipseInRect(context, ellipseRect);
        CGContextSetRGBFillColor (context, 0.8, 0.8, 0.8, 0.4);
        CGContextFillEllipseInRect(context, ellipseRect);
        CGContextStrokePath(context);
    }
    
    
    
    
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


+(CGFloat)cellWidth{
    return 320;
}
@end
