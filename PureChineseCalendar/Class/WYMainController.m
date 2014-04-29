//
//  WYHorizontalScrollViewController.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-2-16.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYMainController.h"
#import "WYCurrentMonthView.h"
#import "WYLunarMap.h"


//#import "UIView+Utils.h"
//#import "DeviceCommon.h"
//#import "WYParallaxMotion.h"






@interface WYMainController ()
{
    __weak IBOutlet UIScrollView *verticalScrollView;
    __weak IBOutlet UIImageView *backImageView;
    
    
    __weak IBOutlet UILabel *lunarYearLabel;
    __weak IBOutlet UILabel *lunarMonthLabel;
    __weak IBOutlet UILabel *solarDayLabel;
    __weak IBOutlet UIView *todayView;
    
    __weak IBOutlet UILabel *yearMonthLabel;
    __weak IBOutlet UIView *yearMonthView;

}
@end

@implementation WYMainController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 背影
//    UIImage *img = [UIImage imageNamed:@"backImage"];
//    backImageView.image = img;
    
    // 视差效果
//    [WYParallaxMotion addParallaxMotionForView:lunarMonthLabel];
//    [WYParallaxMotion addParallaxMotionForView:lunarMonthLabel];
//    [WYParallaxMotion addParallaxMotionForView:solarDayLabel];
    
    // 显示今天农历日期
    NSDate *date = [NSDate date];
    NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    NSDateComponents *lunarDateComponents = [chineseCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    NSString *lunarZodiac = [WYLunarMap instance].lunarZodiac[lunarDateComponents.year%12 - 1];
    NSString *lunarYear = [WYLunarMap instance].arrayYear[lunarDateComponents.year - 1];
    NSString *lunarMonth = [WYLunarMap instance].arrayMonth[lunarDateComponents.month - 1];
    NSString *lunarDay = [WYLunarMap instance].arrayDay[lunarDateComponents.day - 1];
    
    // 显示今天公历日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy - M - d   EEEE";
    NSString* dateString = [formatter stringFromDate:date];
    
    lunarYearLabel.text = [NSString stringWithFormat:@"%@ ‑ %@年", lunarYear, lunarZodiac];
    lunarMonthLabel.text = [NSString stringWithFormat:@"%@‑%@", lunarMonth, lunarDay];
    solarDayLabel.text = dateString;


    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:date];
//    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSUInteger solarYear = [dateComponents year];
    NSUInteger solarMonth = [dateComponents month];
    
    
    // 只前后各加载5个月的，在滑动减速时，再加载一定量的
    // 显示月历表
    verticalScrollView.contentSize = CGSizeMake(verticalScrollView.bounds.size.width * 12, verticalScrollView.bounds.size.height) ;
    
    CGFloat time;
    time = BNRTimeBlock(^{
        for (int i = 1; i <= 12; i++) {
            
            BOOL isCurrentMonth = NO;
            if (solarMonth == i) {
                isCurrentMonth = YES;
            }
            WYCurrentMonthView *monthView = [[WYCurrentMonthView alloc] initWithYear:solarYear month:i isCurrentMonth:isCurrentMonth];
            monthView.center = CGPointMake(160 + (i-1)*320, verticalScrollView.bounds.size.height/2);
            [verticalScrollView addSubview:monthView];
        }
    });
    printf ("加载12个月的时间: %f\n", time);
    

    verticalScrollView.contentOffset = CGPointMake((solarMonth - 1) * 320, 0);
    
    // TODO: 根据scroll view的偏移来计算要显示月历的年、月
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    if (yearMonthView.alpha == 0) {
//        [UIView animateWithDuration:0.3 animations:^{
//            yearMonthView.alpha = 1;
//            todayView.alpha = 0;
//        }];
//        
//    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger month = (NSUInteger)scrollView.contentOffset.x / 320 + 1;
    yearMonthLabel.text = [NSString stringWithFormat:@"%d年%d月", 2014, month];
    
}

#import <mach/mach_time.h>  // for mach_absolute_time() and friends

#define LOOPAGE 100000000

CGFloat BNRTimeBlock (void (^block)(void)) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
    
}

#pragma mark - 点击事件
- (IBAction)tapAction:(id)sender {
    
//    if (yearMonthView.alpha == 0) {
//        [UIView animateWithDuration:0.3 animations:^{
//            yearMonthView.alpha = 1;
//            todayView.alpha = 0;
//        }];
//        
//    }else{
//        [UIView animateWithDuration:0.3 animations:^{
//            yearMonthView.alpha = 0;
//            todayView.alpha = 1;
//        }];
//        
//    }
}

@end
