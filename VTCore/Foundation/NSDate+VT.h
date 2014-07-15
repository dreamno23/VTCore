//
//  NSDate+VT.h
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (VT)
//@"yyyy-MM-dd HH:mm:ss"
- (NSString *)stringWithFormat:(NSString *)aFormat;

//将日期转换为当前时区的日期
- (NSDate *)localTimeDate;

//是否是同一天
- (BOOL)isSameDay:(NSDate *)date;

//判断是否 今天，明天，后天，不是 返回星期 eg:2014-04-16，星期三，16:40
- (NSString *)detailDateStringWithDate;
@end


@interface NSDate (CALENDAR)

- (NSDate *)cc_dateByMovingToBeginningOfDay:(NSCalendar *)calendar;

- (NSDate *)cc_dateByMovingToEndOfDay:(NSCalendar *)calendar;

//上一天
- (NSDate *)cc_dateByMovingToThePreviousDay:(NSCalendar *)calendar;
//下一天
- (NSDate *)cc_dateByMovingToTheFollowingDay:(NSCalendar *)calendar;
//某天
- (NSDate *)cc_dateByMovingToDay:(NSInteger)day calendar:(NSCalendar *)calendar;

//本年第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheYear:(NSCalendar *)calendar;
//本星期最后一天
- (NSDate *)cc_dateByMovingToLastDayOfTheYear:(NSCalendar *)calendar;
//上一年第一天
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousYear:(NSCalendar *)calendar;
//下一年第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingYear:(NSCalendar *)calendar;
//某年第一天
- (NSDate *)cc_dateByMovingToFirstDayOfYear:(NSInteger)year calendar:(NSCalendar *)calendar;

//本月第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth:(NSCalendar *)calendar;
//本月最后一天
- (NSDate *)cc_dateByMovingToLastDayOfTheMonth:(NSCalendar *)calendar;
//上月第一天
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth:(NSCalendar *)calendar;
//上月最后一天
- (NSDate *)cc_dateByMovingToLastDayOfLastMonth:(NSCalendar *)calendar;
//下月第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth:(NSCalendar *)calendar;
//某月第一天
- (NSDate *)cc_dateByMovingToFirstDayOfMonth:(NSInteger)month calendar:(NSCalendar *)calendar;

//本星期第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheWeek:(NSCalendar *)calendar;
//本星期最后一天
- (NSDate *)cc_dateByMovingToLastDayOfTheWeek:(NSCalendar *)calendar;
//上星期第一天
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousWeek:(NSCalendar *)calendar;
//下星期第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingWeek:(NSCalendar *)calendar;
//某星期第一天
- (NSDate *)cc_dateByMovingToFirstDayOfWeek:(NSInteger)week calendar:(NSCalendar *)calendar;

- (NSDateComponents *)cc_componentsForMonthDayAndYear:(NSCalendar *)calendar;

- (NSUInteger)cc_weekday:(NSCalendar *)calendar;

- (NSUInteger)cc_monthday:(NSCalendar *)calendar;

- (NSUInteger)cc_year:(NSCalendar *)calendar;

- (NSUInteger)cc_month:(NSCalendar *)calendar;

- (NSUInteger)cc_numberOfDaysInMonth:(NSCalendar *)calendar;
//间隔天数
- (NSUInteger)cc_numberOfDaysFromDate:(NSDate *)date calendar:(NSCalendar *)calendar;
//间隔星期数
- (NSUInteger)cc_numberOfWeeksFromDate:(NSDate *)date calendar:(NSCalendar *)calendar;
//间隔月数
- (NSUInteger)cc_numberOfMonthsFromDate:(NSDate *)date calendar:(NSCalendar *)calendar;
//间隔年数
- (NSUInteger)cc_numberOfYearsFromDate:(NSDate *)date calendar:(NSCalendar *)calendar;
@end
