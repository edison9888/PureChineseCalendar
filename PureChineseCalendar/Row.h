//
//  Row.h
//  reuse
//
//  Created by wangyang on 14-5-15.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYDate;
@interface Row : UIView
@property (nonatomic, strong) WYDate *startDate;
@property (nonatomic, readonly, strong) WYDate *endDate;

@end
