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
    if (self ) {
        _lunarZodiac = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
        _arrayMonth = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月", nil];
        
        _arrayDay = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
        _weeks = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        
        _arrayYear = @[@"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉", @"甲戌", @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛巳", @"壬午", @"癸未", @"甲申", @"乙酉", @"丙戌", @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳", @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌", @"己亥", @"庚子", @"辛丑", @"任寅", @"癸卯", @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥", @"壬子", @"癸丑", @"甲寅", @"乙卯", @"丙辰", @"丁己", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥"];
        
        
        _gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        _chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-d"];
        
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
        UIColor *defaultColor = [UIColor colorWithRed:25.0/255 green:25.0/255 blue:25.0/255 alpha:1.0];
        NSMutableParagraphStyle *styleCenter = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [styleCenter setAlignment:NSTextAlignmentCenter];
        _weekDayFontAttributes = @{NSForegroundColorAttributeName : defaultColor,
                                   NSFontAttributeName:font,
                                   NSParagraphStyleAttributeName:styleCenter};
        
        UIColor *redColor = [UIColor colorWithRed:255.0/255 green:0/255 blue:0/255 alpha:1.0];
        _lunarMonthFontAttributes = @{NSForegroundColorAttributeName : redColor,
                                      NSFontAttributeName:font,
                                      NSParagraphStyleAttributeName:styleCenter};
        
        font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
        NSMutableParagraphStyle *styleLeft = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [styleLeft setAlignment:NSTextAlignmentLeft];
        _yearMonthFontAttributes = @{NSForegroundColorAttributeName : defaultColor,
                                     NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:styleLeft};
    }
    
	   
    return self;
}
@end
