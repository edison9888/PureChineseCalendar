//
//  WYLunarMap.h
//  PureChineseCalendar
//
//  Created by wangyang on 14-4-25.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <Foundation/Foundation.h>



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

@property (nonatomic, strong) NSCalendar *gregorianCalendar;
@property (nonatomic, strong) NSCalendar *chineseCalendar;
@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) NSDictionary *weekDayFontAttributes;
@property (nonatomic, strong) NSDictionary *yearMonthFontAttributes;
@property (nonatomic, strong) NSDictionary *lunarMonthFontAttributes;
+ (instancetype) instance;
@end
