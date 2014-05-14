#import "VerticalScrollView.h"
#import "WYMonthRow.h"
#import "WYLunarMap.h"

@interface VerticalScrollView () <UIScrollViewDelegate>{
    NSMutableArray *visibleCells;
    UIView *cellContainerView;
}

@end


@implementation VerticalScrollView


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.contentSize = CGSizeMake(320, 3000);
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        
        visibleCells = [[NSMutableArray alloc] init];
        
        cellContainerView = [[UIView alloc] init];
        cellContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        [self addSubview:cellContainerView];

        [cellContainerView setUserInteractionEnabled:YES];
        
        // hide horizontal scroll indicator so our recentering trick is not revealed
        [self setShowsVerticalScrollIndicator:NO];
        self.canCancelContentTouches=YES;
    }
    return self;
}

#pragma mark - Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary {
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentHeight = [self contentSize].height;
    CGFloat centerOffsetY = (contentHeight - [self bounds].size.height) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
    
    if (distanceFromCenter > (contentHeight / 4.0)) {
        self.contentOffset = CGPointMake(0, centerOffsetY);
        
        // move content by the same amount so it appears to stay still
        for (WYMonthRow *view in visibleCells) {
            CGPoint center = [cellContainerView convertPoint:view.center toView:self];
            center.y -= (currentOffset.y - centerOffsetY);
            view.center = [self convertPoint:center toView:cellContainerView];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    
    CGRect visibleBounds = [self convertRect:[self bounds] toView:cellContainerView];
    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);

    [self tileCellsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
    
}


#pragma mark - Cell Tiling

- (WYMonthRow *)insertCellForDate:(WYDate *)date{
    
    WYMonthRow *cell = [[WYMonthRow alloc] initWithStartDate:date];
    [cellContainerView addSubview:cell];
    return cell;
}

- (CGFloat)placeNewCellOnTop:(CGFloat)top ofDate:(WYDate *)date{
    WYMonthRow *cell=[self insertCellForDate:date];
    
    [visibleCells insertObject:cell atIndex:0];
    
    CGRect frame = [cell frame];
    if (visibleCells.count == 1) {
        frame.origin.y = top;
    }else{
        frame.origin.y = top - cell.frame.size.height;
    }
    
    frame.origin.x = 0;
    [cell setFrame:frame];
    
    return CGRectGetMinY(frame);
}

- (CGFloat)placeNewCellOnBottom:(CGFloat)bottom ofDate:(WYDate *)date{
    WYMonthRow *cell=[self insertCellForDate:date];
    
    [visibleCells addObject:cell];
    
    CGRect frame = [cell frame];
    frame.origin.x = 0;
    frame.origin.y = bottom;

    [cell setFrame:frame];
    
    return CGRectGetMaxY(frame);
}


- (void)tileCellsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY {
    
    // 第一次添加cell
    if ([visibleCells count] == 0) {
        [self placeNewCellOnTop:minimumVisibleY ofDate:[WYDate dateWithYear:[WYLunarMap instance].currentDate.year month:[WYLunarMap instance].currentDate.month day:1]];
    }
    
    // 往下文添加cell
    WYMonthRow *lastCell = [visibleCells lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastCell frame]);
    while (bottomEdge < maximumVisibleY) {
        
        WYDate *date = [lastCell.endDate nextDate];
        if (date.day == 1) {
            bottomEdge +=10;
        }
        
        uint64_t start = mach_absolute_time ();
        bottomEdge = [self placeNewCellOnBottom:bottomEdge ofDate:date];
        
        uint64_t end = mach_absolute_time ();
        uint64_t elapsed = end - start;
        mach_timebase_info_data_t info;
        mach_timebase_info(&info);
        uint64_t nanos = elapsed * info.numer / info.denom;
        CGFloat time = (CGFloat)nanos / NSEC_PER_SEC;
        NSLog(@"bottomEdge加载时间 %f", time);
        
        lastCell = [visibleCells lastObject];
        
    }
    
    // 在上方插入新的cell
    WYMonthRow *firstCell = [visibleCells objectAtIndex:0];
    CGFloat topEdge = CGRectGetMinY([firstCell frame]);
    while (topEdge > minimumVisibleY) {
        
        uint64_t start = mach_absolute_time ();
        WYDate *date;
        if (firstCell.startDate.day == 1) {
            topEdge -= 10;
            if (firstCell.startDate.weekday == 1) {
                date = [firstCell.startDate dateWithOffsetDay:-7];
            }else{
                double offset = 0-(double)firstCell.startDate.weekday + 1;
                date = [firstCell.startDate dateWithOffsetDay:offset];
            }
        }else if (firstCell.startDate.day <= 7 ) {
            date = [WYDate dateWithYear:firstCell.startDate.year month:firstCell.startDate.month day:1];
        }else{
            date = [WYDate dateWithYear:firstCell.startDate.year month:firstCell.startDate.month day:firstCell.startDate.day - 7];
        }
        
        
        
        
        topEdge = [self placeNewCellOnTop:topEdge ofDate:date];
        
        uint64_t end = mach_absolute_time ();
        uint64_t elapsed = end - start;
        mach_timebase_info_data_t info;
        mach_timebase_info(&info);
        uint64_t nanos = elapsed * info.numer / info.denom;
        CGFloat time = (CGFloat)nanos / NSEC_PER_SEC;
        NSLog(@"topEdge加载时间 %f", time);
        firstCell = [visibleCells objectAtIndex:0];
    }
    
    // 对于已经在视线外的cell，移除
    lastCell = [visibleCells lastObject];
    while ([lastCell frame].origin.y > maximumVisibleY) {
        [lastCell removeFromSuperview];
        [visibleCells removeLastObject];
        lastCell = [visibleCells lastObject];
    }

    firstCell = [visibleCells objectAtIndex:0];
    while (CGRectGetMaxY([firstCell frame]) < minimumVisibleY) {
        [firstCell removeFromSuperview];
        [visibleCells removeObjectAtIndex:0];
        firstCell = [visibleCells objectAtIndex:0];
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    CGRect visibleBounds = [self convertRect:[self bounds] toView:cellContainerView];
//    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
//    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
//    
//    // 对于已经在视线外的cell，移除
//    WYMonthRow *lastCell = [visibleCells lastObject];
//    while ([lastCell frame].origin.y > maximumVisibleY) {
//        [lastCell removeFromSuperview];
//        [visibleCells removeLastObject];
//        lastCell = [visibleCells lastObject];
//    }
//    
//    WYMonthRow *firstCell = [visibleCells objectAtIndex:0];
//    while (CGRectGetMaxY([firstCell frame]) < minimumVisibleY) {
//        [firstCell removeFromSuperview];
//        [visibleCells removeObjectAtIndex:0];
//        firstCell = [visibleCells objectAtIndex:0];
//    }
//
//}
@end
