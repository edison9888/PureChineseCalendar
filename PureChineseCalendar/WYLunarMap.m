//
//  WYLunarMap.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-4-25.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYLunarMap.h"

@implementation WYLunarMap
+ (instancetype) instance{
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[WYLunarMap alloc] init];
    });
    
    return instance;
}

- (id)init{
    self = [super init];
    if (!self ) {
        return nil;
    }
    
    _heavenlyStems = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸",nil];
	_earthlyBranches = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
	_lunarZodiac = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
	
	_solarTerms = [NSArray arrayWithObjects:@"立春", @"雨水", @"惊蛰", @"春分", @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分", @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至", @"小寒", @"大寒", nil];
	
	_arrayMonth = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月", nil];
	
	_arrayDay = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
    _weeks = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    return self;
}
@end
