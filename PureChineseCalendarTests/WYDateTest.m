//
//  WYDateTest.m
//  PureChineseCalendar
//
//  Created by wangyang on 14-5-1.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WYDate.h"
@interface WYDateTest : XCTestCase

@end

@implementation WYDateTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testDate
{
    WYDate *testDate = [[WYDate alloc] initWithYear:2014 month:6];
    WYDate *date0 = [testDate dateByAddingMonths:-3];
    if (date0.year != testDate.year) {
        XCTFail(@"date0 year 计算错误");
    }
    if (date0.month != testDate.month - 3) {
        XCTFail(@"date0 month 计算错误");
    }
    
    WYDate *date1 = [testDate dateByAddingMonths:-13];
    if (date1.year != 2013) {
        XCTFail(@"date1 year 计算错误");
    }
    if (date1.month != 5) {
        XCTFail(@"date1 month 计算错误");
    }
    
    WYDate *date2 = [testDate dateByAddingMonths:-31];
    if (date2.year != 2012) {
        XCTFail(@"date2 year 计算错误");
    }
    if (date2.month != 11) {
        XCTFail(@"date2 month 计算错误");
    }
    
}
@end
