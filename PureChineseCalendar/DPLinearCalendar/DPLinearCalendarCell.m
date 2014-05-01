//
//  DPLinearCalendarCell.m
//  DPLinearCalendar
//
//  Created by Kostas Antonopoulos on 9/28/12.
//  Copyright (c) 2012 Kostas Antonopoulos. All rights reserved.
//

#import "DPLinearCalendarCell.h"
#import "DPLinearCalendarScrollView.h"
#import "WYDate.h"

@interface DPLinearCalendarCell () {
    UIView *selectedBgView;
    UIButton *btn;
}

@end

@implementation DPLinearCalendarCell
@synthesize cellDate = _cellDate;

- (DPLinearCalendarCell*)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];

    if (self) {
        
    }
    return self;
}


+(CGFloat)cellWidth{
    return 65;
}

//-(void)selectCell{
//    if (!selectedBgView) {
//        selectedBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 14, self.frame.size.width-25, 30)];
//        [selectedBgView setBackgroundColor:[UIColor redColor]];
//    }
//    [self insertSubview:selectedBgView atIndex:0];
//}
//
//-(void)unselectCell{
//    [selectedBgView removeFromSuperview];
//}
//
//-(void)cellPressed:(UIButton*)sender{
//    [self.linearCalendar setSelectedDate:self.cellDate];
//}

@end
