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
#import "DPLinearCalendarScrollView.h"
#import <mach/mach_time.h>  // for mach_absolute_time() and friends

@interface WYMainController () <DPLinearCalendarScrollViewDataSource>
{
    __weak IBOutlet DPLinearCalendarScrollView *hScrollView;
    
    __weak IBOutlet UILabel *lunarYearLabel;
    __weak IBOutlet UILabel *lunarMonthLabel;
    __weak IBOutlet UILabel *solarDayLabel;
    __weak IBOutlet UIView *todayView;
    
    __weak IBOutlet UILabel *testLabel;
    uint64_t start;
}
@end

@implementation WYMainController

- (void)viewDidLoad
{
    [super viewDidLoad];

    start = mach_absolute_time ();
    
    // 背景
//    UIImage *img = [UIImage imageNamed:@"backImage"];
//    backImageView.image = img;
    

    
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

    // scroll view设定
    hScrollView.linearDatasource = self;
    hScrollView.wrapEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
#warning 测试用
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    uint64_t nanos = elapsed * info.numer / info.denom;
    testLabel.text = [NSString stringWithFormat:@"%f", (CGFloat)nanos / NSEC_PER_SEC];
}
#pragma mark - scroll view data source
-(WYCurrentMonthView*) linearScrollViewCellForDate:(WYDate *)date isCurrentMonth:(BOOL)flag;
{
    WYCurrentMonthView *monthView = [[WYCurrentMonthView alloc] initWithDate:date isCurrentMonth:flag];
    
    return monthView;
}

- (IBAction)todayAction:(id)sender {
    // TODO: 要先研究DPLinearCalendarScrollView的源代码，然后再回来做todayAction功能。不研究明白，这个地方做不出来
}




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



@end
