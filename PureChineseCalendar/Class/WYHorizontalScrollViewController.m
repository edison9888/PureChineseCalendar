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
//@import <UIImage+BlurredFrame.h>
#import <UIImage+BlurredFrame.h>
@interface WYHorizontalScrollViewController ()
{
    __weak IBOutlet UIScrollView *horizontalScrollView;
    __weak IBOutlet UIImageView *backImageView;
    
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
    
    UIImage *img = [UIImage imageNamed:@"backImage"];
    CGRect frame = CGRectMake(0, 0, img.size.width, img.size.height);
    
    backImageView.image = [img applyLightEffectAtFrame:frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
