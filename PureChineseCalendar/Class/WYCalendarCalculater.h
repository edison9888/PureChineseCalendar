//
//  WYCalendarCalculater.h
//  PureChineseCalendar
//
//  Created by wangyang on 14-2-15.
//  Copyright (c) 2014年 com.wy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  应用程序全局只使用一个WYCalendarCalculater。
 */
@interface WYCalendarCalculater : NSObject

+ (WYCalendarCalculater *)shareInstance;

// lunar: 农历（阴的）
// solar: 公历（太阳的）

/**
 *  农历转公历
 *
 *  农历转公历时，如果阴历那一月是闰月，则需额外传一个参数，才能得到正确的公历日期
 *
 *  @param year   农历年
 *  @param month  农历月
 *  @param day    农历日
 *  @param isLeap 农历月是否为闰月
 *
 *  @return 公历信息。字典格式描述如下
 *          注: l 前缀表示 lunar: 农历（阴的）
 *              s 前缀表示 solar: 公历（太阳的）
 *         {
                cDay: "戊戌"
                , cMonth: "丁未"
                , cYear: "壬辰"
                , isLeap: false             // 该月是否为闰月
                , lDay: 18
                , lMonth: 6
                , lYear: 2012
                , lunarDay: "十八"
                , lunarFestival: ""
                , lunarMonth: "六"
                , lunarYear: "龙"
                , sDay: 5
                , sMonth: 8
                , sYear: 2012
                , solarFestival: ""         // 节日
                , solarTerms: ""            // 节气
                , week: "日"                // 周几
            }
 *
 */
- (NSDictionary *)lunarToSolarWithYear:(NSInteger)year
                                  month:(NSInteger)month
                                   day:(NSInteger)day
                            monothLeap:(BOOL)isLeap;
/**
 *  公历转农历
 *
 *  @param year   公历年
 *  @param month  公历月
 *  @param day    公历日
 *  @param isLeap 公历月是否为闰月
 *
 *  @return 农历信息。字典格式描述参见方法：lunarToSolarWithYear:month:day:monothLeap
 */
- (NSDictionary *)solarToLunarWithYear:(NSInteger)year
                                  month:(NSInteger)month
                                    day:(NSInteger)day;

- (NSDictionary *)lunarOfToday;
@end
