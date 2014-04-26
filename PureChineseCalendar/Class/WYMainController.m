//
//  WYHorizontalScrollViewController.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-2-16.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYMainController.h"

//#import "UIView+Utils.h"
//#import "DeviceCommon.h"
#import "WYParallaxMotion.h"


#import "WYCurrentMonthView.h"
#import "WYLunarMap.h"

#import <UIImage+BlurredFrame.h>


@interface WYMainController ()
{
    __weak IBOutlet UIScrollView *verticalScrollView;
    __weak IBOutlet UIImageView *backImageView;
    
    
    __weak IBOutlet UILabel *lunarYearLabel;
    __weak IBOutlet UILabel *lunarMonthLabel;
    __weak IBOutlet UILabel *solarDayLabel;
}
@end

@implementation WYMainController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 背影
    UIImage *img = [UIImage imageNamed:@"backImage"];
    CGRect frame = CGRectMake(0, 0, img.size.width, img.size.height);
    backImageView.image = [img applyLightEffectAtFrame:frame];
    
    // 视差效果
    [WYParallaxMotion addParallaxMotionForView:lunarMonthLabel];
    [WYParallaxMotion addParallaxMotionForView:lunarMonthLabel];
    [WYParallaxMotion addParallaxMotionForView:solarDayLabel];
    
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

    
    // 显示月历表
    verticalScrollView.contentSize = verticalScrollView.bounds.size;
    
    WYCurrentMonthView *monthView = [[WYCurrentMonthView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    monthView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
    [verticalScrollView addSubview:monthView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
