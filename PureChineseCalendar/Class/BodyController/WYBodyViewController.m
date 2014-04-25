//
//  WYViewController.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-1-31.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYBodyViewController.h"
#import "WYParallaxMotion.h"
#import "WYLunarMap.h"

@interface WYBodyViewController ()
{
    __weak IBOutlet UILabel *lunarYearLabel;
    __weak IBOutlet UILabel *lunarMonthLabel;
    __weak IBOutlet UILabel *solarDayLabel;
    
}
@end

@implementation WYBodyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [WYParallaxMotion addParallaxMotionForView:lunarMonthLabel];
    [WYParallaxMotion addParallaxMotionForView:lunarMonthLabel];
    [WYParallaxMotion addParallaxMotionForView:solarDayLabel];
    
    NSDate *date = [NSDate date];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *solarDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
//    NSInteger year = [solarDateComponents year];
//    NSInteger month = [solarDateComponents month];
//    NSInteger today = [solarDateComponents day];
    
    NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    NSDateComponents *lunarDateComponents = [chineseCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    NSString *lunarMonth = [WYLunarMap instance].arrayMonth[lunarDateComponents.month - 1];
    NSString *lunarDay = [WYLunarMap instance].arrayDay[lunarDateComponents.day - 1];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy - M - d   EEEE";
    NSString* dateString = [formatter stringFromDate:date];
    
    lunarMonthLabel.text = [NSString stringWithFormat:@"%@ %@", lunarMonth, lunarDay];
    solarDayLabel.text = dateString;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
