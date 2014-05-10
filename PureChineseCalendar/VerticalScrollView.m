/*
     File: InfiniteScrollView.m
 Abstract: This view tiles UILabel instances to give the effect of infinite scrolling side to side.
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import "VerticalScrollView.h"
#import "WYCurrentMonthView.h"

@interface VerticalScrollView () <UIScrollViewDelegate>{
    NSMutableArray *visibleCells;
    UIView         *cellContainerView;
    WYDate *currentDate;
}

@end


@implementation VerticalScrollView


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.contentSize = CGSizeMake(960, self.frame.size.height);
        self.delegate = self;
        visibleCells = [[NSMutableArray alloc] init];
        
        cellContainerView = [[UIView alloc] init];
        cellContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height/2);
        [self addSubview:cellContainerView];

        [cellContainerView setUserInteractionEnabled:YES];
        
        // hide horizontal scroll indicator so our recentering trick is not revealed
        [self setShowsHorizontalScrollIndicator:NO];
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
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0)) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        // move content by the same amount so it appears to stay still
        for (WYCurrentMonthView *view in visibleCells) {
            CGPoint center = [cellContainerView convertPoint:view.center toView:self];
            center.x += (centerOffsetX - currentOffset.x);
            view.center = [self convertPoint:center toView:cellContainerView];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    

    [self recenterIfNecessary];
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:[self bounds] toView:cellContainerView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);

    [self tileCellsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
}


#pragma mark - Cell Tiling
#pragma mark Cell Create

- (WYCurrentMonthView *)insertCellForDate:(WYDate *)date isCurrentMonth:(BOOL)flag{
    
    WYCurrentMonthView *cell = [[WYCurrentMonthView alloc] initWithDate:date isCurrentMonth:flag];
        
    [cellContainerView addSubview:cell];
    return cell;
}


- (CGFloat)placeNewCellOnRight:(CGFloat)rightEdge ofDate:(WYDate *)date{
    BOOL isCurrentMonth = [date isEqualToDate:currentDate];
    WYCurrentMonthView *cell=[self insertCellForDate:date isCurrentMonth:isCurrentMonth];
    
    [visibleCells addObject:cell]; // add rightmost label at the end of the array
    
    CGRect frame = [cell frame];
    frame.origin.x = rightEdge;
    [cell setFrame:frame];
        
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewCellOnLeft:(CGFloat)leftEdge ofDate:(WYDate *)date{
    BOOL isCurrentMonth = [date isEqualToDate:currentDate];
    WYCurrentMonthView *cell=[self insertCellForDate:date isCurrentMonth:isCurrentMonth];
    
    [visibleCells insertObject:cell atIndex:0]; // add leftmost label at the beginning of the array
    
    CGRect frame = [cell frame];
    frame.origin.x = leftEdge - frame.size.width;
    [cell setFrame:frame];
    
    return CGRectGetMinX(frame);
}

- (void)tileCellsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX {
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([visibleCells count] == 0) {
        [self placeNewCellOnRight:minimumVisibleX ofDate:currentDate];
    }
    
    // add cell that are missing on right side
    WYCurrentMonthView *lastCell = [visibleCells lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastCell frame]);
    while (rightEdge < maximumVisibleX) {
        rightEdge = [self placeNewCellOnRight:rightEdge ofDate:[lastCell.cellDate dateByAddingMonths:1]];
    }
    
    // add labels that are missing on left side
    WYCurrentMonthView *firstCell = [visibleCells objectAtIndex:0];
    CGFloat leftEdge = CGRectGetMinX([firstCell frame]);
    while (leftEdge > minimumVisibleX) {
        leftEdge = [self placeNewCellOnLeft:leftEdge ofDate:[firstCell.cellDate dateByAddingMonths:-1]];
    }
    
    // remove labels that have fallen off right edge
    lastCell = [visibleCells lastObject];
    while ([lastCell frame].origin.x > maximumVisibleX) {
        [lastCell removeFromSuperview];
        [visibleCells removeLastObject];
        lastCell = [visibleCells lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstCell = [visibleCells objectAtIndex:0];
    while (CGRectGetMaxX([firstCell frame]) < minimumVisibleX) {
        [firstCell removeFromSuperview];
        [visibleCells removeObjectAtIndex:0];
        firstCell = [visibleCells objectAtIndex:0];
    }
}
@end
