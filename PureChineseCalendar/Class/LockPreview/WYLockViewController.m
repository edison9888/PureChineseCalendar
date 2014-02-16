//
//  WYLockViewController.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-2-1.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYLockViewController.h"

@interface WYLockViewController ()

@end

@implementation WYLockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)tapAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


@end
