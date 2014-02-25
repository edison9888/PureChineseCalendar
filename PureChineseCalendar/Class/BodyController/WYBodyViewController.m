//
//  WYViewController.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-1-31.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYBodyViewController.h"
#import "WYLockViewController.h"
#import "WYCalendarCalculater.h"

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
    NSDictionary *info = [[WYCalendarCalculater shareInstance] lunarOfToday];
    lunarYearLabel.text = [NSString stringWithFormat:@"%@年  %@",
                           info[@"cYear"], info[@"lunarYear"]];
    lunarMonthLabel.text = [NSString stringWithFormat:@"%@月  %@",
                            info[@"lunarMonth"], info[@"lunarDay"]];
    solarDayLabel.text = [NSString stringWithFormat:@"%@ - %@ - %@   星期%@", info[@"sYear"], info[@"sMonth"], info[@"sDay"], info[@"week"]];
    
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [lunarYearLabel addMotionEffect:group];
    [lunarMonthLabel addMotionEffect:group];
    [solarDayLabel addMotionEffect:group];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
