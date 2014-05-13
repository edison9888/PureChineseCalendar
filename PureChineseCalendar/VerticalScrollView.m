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
        cellContainerView.backgroundColor = [UIColor greenColor];
        cellContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
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
        self.contentOffset = CGPointMake(0, centerOffsetY);
        
        // move content by the same amount so it appears to stay still
        for (WYMonthRow *view in visibleCells) {
            CGPoint center = [cellContainerView convertPoint:view.center toView:self];
            center.x += (currentOffset.y - centerOffsetY);
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

- (WYMonthRow *)insertCellForDate:(WYDate *)date{
    
    WYMonthRow *cell = [[WYMonthRow alloc] initWithStartDate:date];
    [cellContainerView addSubview:cell];
    return cell;
}

- (CGFloat)placeNewCellOnTop:(CGFloat)top ofDate:(WYDate *)date{
    WYMonthRow *cell=[self insertCellForDate:date];
    
    [visibleCells insertObject:cell atIndex:0];
    
    CGRect frame = [cell frame];
    frame.origin.y = top;
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
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([visibleCells count] == 0) {
        [self placeNewCellOnTop:minimumVisibleY ofDate:[WYDate dateWithYear:currentDate.year month:currentDate.month day:1]];
    }
    
    // add cell that are missing on right side
    WYMonthRow *lastCell = [visibleCells lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastCell frame]);
    while (bottomEdge < maximumVisibleY) {
        bottomEdge = [self placeNewCellOnBottom:bottomEdge ofDate:[lastCell.endDate nextDate]];
        lastCell = [visibleCells lastObject];
    }
    
    // 在上方插入新的row
    WYMonthRow *firstCell = [visibleCells objectAtIndex:0];
    CGFloat topEdge = CGRectGetMinY([firstCell frame]);
    while (topEdge > minimumVisibleY) {
        WYDate *date;
        if (firstCell.startDate.day == 1) {
            if (firstCell.startDate.weekday == 1) {
                date = [firstCell.startDate dateWithOffsetDay:-7];
            }else{
                double offset = 0-(double)firstCell.startDate.weekday + 1;
                date = [firstCell.startDate dateWithOffsetDay:offset];
            }
            
//            date = [firstCell.startDate preDate];
//            date = [date dateWithOffsetDay:7-date.weekday];
        }else if (firstCell.startDate.day < 7 ) {
            date = [WYDate dateWithYear:firstCell.startDate.year month:firstCell.startDate.month day:1];
        }else{
            date = [WYDate dateWithYear:firstCell.startDate.year month:firstCell.startDate.month day:firstCell.startDate.day - 7];
        }
        topEdge = [self placeNewCellOnTop:topEdge - firstCell.frame.size.height ofDate:date];
        firstCell = [visibleCells objectAtIndex:0];
    }
    
    // remove labels that have fallen off bottom edge
    lastCell = [visibleCells lastObject];
    while ([lastCell frame].origin.y > maximumVisibleY) {
        [lastCell removeFromSuperview];
        [visibleCells removeLastObject];
        lastCell = [visibleCells lastObject];
    }
    
    // remove labels that have fallen off top edge
    firstCell = [visibleCells objectAtIndex:0];
    while (CGRectGetMaxY([firstCell frame]) < minimumVisibleY) {
        [firstCell removeFromSuperview];
        [visibleCells removeObjectAtIndex:0];
        firstCell = [visibleCells objectAtIndex:0];
    }
}
@end
