//
//  WYCurrentMonthController.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-2-16.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYCurrentMonthController.h"
#import "WYParallaxMotion.h"

@interface WYCurrentMonthController ()
{
    __weak IBOutlet UIButton *firstButton;
    
}
@end

@implementation WYCurrentMonthController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [WYParallaxMotion addParallaxMotionForView:firstButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
