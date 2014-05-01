//
//  DPLinearCalendarCell.h
//  DPLinearCalendar
//
//  Created by Kostas Antonopoulos on 9/28/12.
//  Copyright (c) 2012 Kostas Antonopoulos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPLinearCalendarScrollView;
@class WYDate;

@interface DPLinearCalendarCell : UIView

@property (nonatomic,weak) DPLinearCalendarScrollView *linearCalendar;

@property (nonatomic,strong) WYDate *cellDate;

+(CGFloat)cellWidth;


//-(void)selectCell;
//-(void)unselectCell;

@end
