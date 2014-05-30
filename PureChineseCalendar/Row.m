//
//  Row.m
//  reuse
//
//  Created by wangyang on 14-5-15.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "Row.h"
#import <mach/mach_time.h>
#import "WYDate.h"

@interface Row ()
{
    
    IBOutletCollection(UILabel) NSArray *dayLabel;
    IBOutletCollection(UILabel) NSArray *lunarLabels;
    
}
@end

@implementation Row

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setStartDate:(WYDate *)startDate
{
    _startDate = startDate;
    // 从startDate是星期几这个来决定endDate是相对startDate多了几天
    NSUInteger endDay = startDate.day + (7 - startDate.weekday);
    if (endDay <= _startDate.daysOfMonth) {
        _endDate = [WYDate dateWithYear:startDate.year month:startDate.month day:endDay];
    }else{
        _endDate = [WYDate dateWithYear:startDate.year month:startDate.month day:startDate.daysOfMonth];
    }

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    uint64_t start = mach_absolute_time ();

    
    WYDate *dateToDraw = _startDate;
    
    while (YES) {
        

        // 显示阳历日期
        NSString *solarDay = [NSString stringWithFormat:@"%lu", (unsigned long)dateToDraw.day];
        
        UILabel *label = dayLabel[dateToDraw.weekday - 1];
        label.text = solarDay;
        
        
        // 显示阴历日期。如果是阴历的1号，要显示阴历月份
        UILabel *lunarLabel = lunarLabels[dateToDraw.weekday - 1];
        if (dateToDraw.intLunarday == 1) {
            lunarLabel.text = dateToDraw.lunarMonth;
        }else{
            lunarLabel.text = dateToDraw.lunarday;
        }
        
        // 如果是今天，就画圈
//        if ([dateToDraw isEqualToDate:[WYLunarMap instance].currentDate]) {
//            CGPoint point = CGPointMake(LEFT + (dateToDraw.weekday - 1) * WIDTH, self.bounds.size.height - WIDTH);
//            CGRect ellipseRect = CGRectMake(point.x, point.y, WIDTH, WIDTH);
//            
//            // 画圈
//            CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
//            //    CGContextAddEllipseInRect(context, ellipseRect);
//            CGContextSetRGBFillColor (context, 0.8, 0.8, 0.8, 0.4);
//            CGContextFillEllipseInRect(context, ellipseRect);
//            CGContextStrokePath(context);
//        }
        
        // 结束标志
        if (dateToDraw.day == _endDate.day) {
            break;
        }
        
        dateToDraw = [dateToDraw nextDate];
    }
    
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    uint64_t nanos = elapsed * info.numer / info.denom;
    CGFloat time = (CGFloat)nanos / NSEC_PER_SEC;
    
}

@end
