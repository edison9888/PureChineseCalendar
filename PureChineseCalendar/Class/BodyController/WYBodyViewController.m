//
//  WYViewController.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-1-31.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYBodyViewController.h"
#import "WYParallaxMotion.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
