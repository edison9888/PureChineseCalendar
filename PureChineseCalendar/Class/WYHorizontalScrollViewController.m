//
//  WYHorizontalScrollViewController.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-2-16.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYHorizontalScrollViewController.h"
#import "WYBodyViewController.h"
#import "WYCurrentMonthController.h"
#import "UIView+Utils.h"
#import "DeviceCommon.h"

@interface WYHorizontalScrollViewController ()
{
    __weak IBOutlet UIScrollView *horizontalScrollView;
    
}
@end

@implementation WYHorizontalScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    horizontalScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, self.view.bounds.size.height);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WYBodyViewController *bodyController = [storyboard instantiateViewControllerWithIdentifier:@"WYBodyViewController"];
    WYCurrentMonthController *monthController = [storyboard instantiateViewControllerWithIdentifier:@"WYCurrentMonthController"];
    bodyController.view.left = 320;
    bodyController.view.top = 0;
    monthController.view.left = 0;
    monthController.view.top = 0;
    
    [horizontalScrollView addSubview:bodyController.view];
    [horizontalScrollView addSubview:monthController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
