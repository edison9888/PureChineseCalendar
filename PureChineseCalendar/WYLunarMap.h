//
//  WYLunarMap.h
//  PureChineseCalendar
//
//  Created by wangyang on 14-4-25.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WYDate;
@interface WYLunarMap : NSObject

// 一些常量
//@property (nonatomic, strong, readonly) NSArray *heavenlyStems;
//@property (nonatomic, strong, readonly) NSArray *earthlyBranches;
//@property (nonatomic, strong, readonly) NSArray *solarTerms;

@property (nonatomic, strong, readonly) NSArray *lunarZodiac;
@property (nonatomic, strong, readonly) NSArray *arrayYear;
@property (nonatomic, strong, readonly) NSArray *arrayMonth;
@property (nonatomic, strong, readonly) NSArray *arrayDay;
@property (nonatomic, strong, readonly) NSArray *weeks;

@property (nonatomic, strong, readonly) NSCalendar *gregorianCalendar;
@property (nonatomic, strong, readonly) NSCalendar *chineseCalendar;
@property (nonatomic, strong, readonly) NSDateFormatter *formatter;

@property (nonatomic, strong, readonly) NSDictionary *weekDayFontAttributes;
@property (nonatomic, strong, readonly) NSDictionary *yearMonthFontAttributes;
@property (nonatomic, strong, readonly) NSDictionary *lunarMonthFontAttributes;

@property (nonatomic, strong, readonly) WYDate *currentDate;
+ (instancetype) instance;
@end
