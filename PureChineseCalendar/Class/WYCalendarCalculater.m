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
                          @"var cc  =new CalendarConverter();"
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
                          @"var cc  =new CalendarConverter();"
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
@end
