//
//  WYCalendarCalculaterTests.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-2-16.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WYCalendarCalculater.h"

@interface WYCalendarCalculaterTests : XCTestCase

@end

@implementation WYCalendarCalculaterTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

- (void)testCalendarCalculater
{
    WYCalendarCalculater *calendar = [WYCalendarCalculater shareInstance];
    NSDictionary *calendarInfo = [calendar solarToLunarWithYear:1888 month:2 day:16];
    
    NSArray *allKeys = calendarInfo.allKeys;
    for (int i = 0; i < allKeys.count; i++) {
        NSString *key = allKeys[i];
        id value = calendarInfo[key];
        if ([value isKindOfClass:[NSString class]]) {
            NSLog(@"%@ : %@", key, value);
        }else{
            NSLog(@"%@ : %@", key, [calendarInfo[key] stringValue]);
        }
    }
    
}

@end
