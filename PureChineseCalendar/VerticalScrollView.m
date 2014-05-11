#import "VerticalScrollView.h"
#import "WYMonthRow.h"

@interface VerticalScrollView () <UIScrollViewDelegate>{
    NSMutableArray *visibleCells;
    UIView *cellContainerView;
    WYDate *currentDate;
}

@end


@implementation VerticalScrollView


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.contentSize = CGSizeMake(320, 3000);
        self.delegate = self;
        visibleCells = [[NSMutableArray alloc] init];
        
        cellContainerView = [[UIView alloc] init];
        cellContainerView.frame = CGRectMake(0, 0, self.contentSize.width/2, self.contentSize.height);
        [self addSubview:cellContainerView];

        [cellContainerView setUserInteractionEnabled:YES];
        
        // hide horizontal scroll indicator so our recentering trick is not revealed
        [self setShowsVerticalScrollIndicator:NO];
        self.canCancelContentTouches=YES;
        
        currentDate = [WYDate currentDate];
    }
    return self;
}

#pragma mark -
#pragma mark Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary {
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentHeight = [self contentSize].height;
    CGFloat centerOffsetY = (contentHeight - [self bounds].size.height) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
    
    if (distanceFromCenter > (contentHeight / 4.0)) {
        self.contentOffset = CGPointMake(centerOffsetY, currentOffset.y);
        
        // move content by the same amount so it appears to stay still
        for (WYMonthRow *view in visibleCells) {
            CGPoint center = [cellContainerView convertPoint:view.center toView:self];
            center.x += (currentOffset.x - centerOffsetY);
            view.center = [self convertPoint:center toView:cellContainerView];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self recenterIfNecessary];
    
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:[self bounds] toView:cellContainerView];
    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);

    [self tileCellsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
}


#pragma mark - Cell Tiling
#pragma mark Cell Create

- (WYMonthRow *)insertCellForDate:(WYDate *)date isCurrentMonth:(BOOL)flag{
    
    WYMonthRow *cell = [[WYMonthRow alloc] initWithStartDate:date];
        
    [cellContainerView addSubview:cell];
    return cell;
}


//- (CGFloat)placeNewCellOnRight:(CGFloat)rightEdge ofDate:(WYDate *)date{
//    BOOL isCurrentMonth = [date isEqualToDate:currentDate];
//    WYCurrentMonthView *cell=[self insertCellForDate:date isCurrentMonth:isCurrentMonth];
//    
//    [visibleCells addObject:cell]; // add rightmost label at the end of the array
//    
//    CGRect frame = [cell frame];
//    frame.origin.x = 0;
//    [cell setFrame:frame];
//        
//    return CGRectGetMaxX(frame);
//}
//
//- (CGFloat)placeNewCellOnLeft:(CGFloat)leftEdge ofDate:(WYDate *)date{
//    BOOL isCurrentMonth = [date isEqualToDate:currentDate];
//    WYCurrentMonthView *cell=[self insertCellForDate:date isCurrentMonth:isCurrentMonth];
//    
//    [visibleCells insertObject:cell atIndex:0]; // add leftmost label at the beginning of the array
//    
//    CGRect frame = [cell frame];
//    frame.origin.x = leftEdge - frame.size.width;
//    [cell setFrame:frame];
//    
//    return CGRectGetMinX(frame);
//}

- (CGFloat)placeNewCellOnTop:(CGFloat)top ofDate:(WYDate *)date{
    BOOL isCurrentMonth = [date isEqualToDate:currentDate];
    WYMonthRow *cell=[self insertCellForDate:date isCurrentMonth:isCurrentMonth];
    
    [visibleCells addObject:cell]; // add rightmost label at the end of the array
    
    CGRect frame = [cell frame];
    frame.origin.y = 0;
    frame.origin.x = 0;
    [cell setFrame:frame];
    
    return CGRectGetMaxY(frame);
}

- (CGFloat)placeNewCellOnBottom:(CGFloat)bottom ofDate:(WYDate *)date{
    BOOL isCurrentMonth = [date isEqualToDate:currentDate];
    WYMonthRow *cell=[self insertCellForDate:date isCurrentMonth:isCurrentMonth];
    
    [visibleCells insertObject:cell atIndex:0]; // add leftmost label at the beginning of the array
    
    CGRect frame = [cell frame];
    frame.origin.x = 0;
    frame.origin.y = bottom - frame.size.height;
    [cell setFrame:frame];
    
    return CGRectGetMinY(frame);
}


- (void)tileCellsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY {
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([visibleCells count] == 0) {
        [self placeNewCellOnTop:minimumVisibleY ofDate:currentDate];
    }
    
    // add cell that are missing on right side
    WYMonthRow *lastCell = [visibleCells lastObject];
    CGFloat rightEdge = CGRectGetMaxY([lastCell frame]);
    while (rightEdge < maximumVisibleY) {
        // 这个地方不对。
        rightEdge = [self placeNewCellOnTop:rightEdge ofDate:[[lastCell.endDate nextDate] dateByAddingMonths:1]];
    }
    
    // add labels that are missing on left side
    WYMonthRow *firstCell = [visibleCells objectAtIndex:0];
    CGFloat leftEdge = CGRectGetMinY([firstCell frame]);
    while (leftEdge > minimumVisibleY) {
        leftEdge = [self placeNewCellOnBottom:leftEdge ofDate:[[firstCell.endDate nextDate] dateByAddingMonths:-1]];
    }
    
    // remove labels that have fallen off right edge
    lastCell = [visibleCells lastObject];
    while ([lastCell frame].origin.y > maximumVisibleY) {
        [lastCell removeFromSuperview];
        [visibleCells removeLastObject];
        lastCell = [visibleCells lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstCell = [visibleCells objectAtIndex:0];
    while (CGRectGetMaxX([firstCell frame]) < minimumVisibleY) {
        [firstCell removeFromSuperview];
        [visibleCells removeObjectAtIndex:0];
        firstCell = [visibleCells objectAtIndex:0];
    }
}
@end
