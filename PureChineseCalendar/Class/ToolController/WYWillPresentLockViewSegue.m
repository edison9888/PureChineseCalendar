//
//  WYWillPresentLockViewSegue.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-2-3.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYWillPresentLockViewSegue.h"

@implementation WYWillPresentLockViewSegue
//- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
//{
//    self = [super initWithIdentifier:identifier source:source destination:destination];
//    if (self) {
//        [source.parentViewController presentViewController:destination animated:NO completion:NULL];
//    }
//    
//    return self;
//}

- (void)perform
{
    UIViewController *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;
    [source.parentViewController presentViewController:destination animated:NO completion:NULL];
}

@end
