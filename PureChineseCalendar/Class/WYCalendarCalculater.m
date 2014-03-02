//
//  WYCalendarCalculater.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-2-15.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import "WYCalendarCalculater.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface WYCalendarCalculater ()
{
    JSContext *context;
    NSArray *lunarDay;
    
}
@end

@implementation WYCalendarCalculater
+ (WYCalendarCalculater *)shareInstance
{
    static WYCalendarCalculater *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[WYCalendarCalculater alloc] init];
    });
    
    return shareInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        lunarDay = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二",@"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"廿", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
        
        
        
        
        // 读取JS文件
        NSString *jsFile = [[NSBundle mainBundle] pathForResource:@"calendar-converter" ofType:@"js"];
        NSString *js = [NSString stringWithContentsOfFile:jsFile encoding:NSUTF8StringEncoding error:nil];
        
        context = [[JSContext alloc] init];
        
        // 给context添加异常处理
        context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
            NSLog(@"%@", exception);
            con.exception = exception;
        };
        
        // 给context添加log方法
        context[@"log"] = ^() {
            NSArray *args = [JSContext currentArguments];
            for (id obj in args) {
                NSLog(@"%@",obj);
            }
        };
        
        
        
        // 执行核心算法文件
        [context evaluateScript:js];
        
        NSString *jsString = [NSString stringWithFormat:
                              @"var cc  =new CalendarConverter();"];
        [context evaluateScript:jsString];
    }
    
    return self;
}

/**
 *  农历转公历
 */
- (NSDictionary *)lunarToSolarWithYear:(NSInteger)year
                                 month:(NSInteger)month
                                   day:(NSInteger)day
                            monothLeap:(BOOL)isLeap

{
    NSString *leapFlag = @"";
    if (isLeap) {
        leapFlag = @"true";
    }else{
        leapFlag = @"false";
    }
    
    NSString *jsString = [NSString stringWithFormat:
                          @"var result = cc.lunar2solar(new Date(%d, %d, %d), %@);",
                          year, month, day, leapFlag];
    
    [context evaluateScript:jsString];
    
    // 根据CalendarConverter的文档，结果是一个字典格式的结果
    NSDictionary *calendarInfo = [context[@"result"] toDictionary];
    
    return calendarInfo;
}
/**
 *  公历转农历
 *
 */
- (NSDictionary *)solarToLunarWithYear:(NSInteger)year
                                 month:(NSInteger)month
                                   day:(NSInteger)day
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var result = cc.solar2lunar(new Date(%d, %d, %d));",
                          year, month, day];
    
    [context evaluateScript:jsString];
    
    // 根据CalendarConverter的文档，结果是一个字典格式的结果
    NSDictionary *calendarInfo = [context[@"result"] toDictionary];
    
    return calendarInfo;
}

- (NSDictionary *)lunarOfToday
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDictionary *info = [self solarToLunarWithYear:components.year month:components.month day:components.day];
    return info;
}

- (NSInteger)daysOfLunarMonth:(NSInteger)lunarMonth forLunarYear:(NSInteger)lunarYear isLeapMonth:(BOOL)leap
{
    // 2012年闰四月，第一个四月大，第二个四月小
    NSString *jsString = [NSString stringWithFormat:
                          @"var days = cc.daysOfMonth(%d, %d, %d);",
                          lunarYear, lunarMonth, leap];
    
    [context evaluateScript:jsString];
    // 根据CalendarConverter的文档，结果是一个字典格式的结果
    int days = [context[@"days"] toInt32];
    
    return days;
}
@end
