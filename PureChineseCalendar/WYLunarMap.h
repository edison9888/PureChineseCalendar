//
//  WYLunarMap.h
//  PureChineseCalendar
//
//  Created by wangyang on 14-4-25.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYLunarMap : NSObject
@property (nonatomic, strong) NSArray *heavenlyStems;
@property (nonatomic, strong) NSArray *earthlyBranches;
@property (nonatomic, strong) NSArray *lunarZodiac;
@property (nonatomic, strong) NSArray *solarTerms;
@property (nonatomic, strong) NSArray *arrayMonth;
@property (nonatomic, strong) NSArray *arrayDay;
@property (nonatomic, strong) NSArray *weeks;
+ (instancetype) instance;
@end
