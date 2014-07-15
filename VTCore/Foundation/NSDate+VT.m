//
//  NSDate+VT.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "NSDate+VT.h"

@implementation NSDate (VT)
- (NSString *)stringWithFormat:(NSString *)aFormat
{
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:aFormat];
    NSString *str = [timeFormat stringFromDate:self];
    return str;
}

//判断是否 今天，明天，后天，不是 返回星期 eg:2014-04-16，星期三，16:40
- (NSString *)detailDateStringWithDate
{
    NSString *dayStr = @"";
    
    if ([self isSameDay:[NSDate date]]) {
        dayStr = @"yyyy-MM-dd,今天,HH:mm";
    } else if ([self isSameDay:[[NSDate date] dateByAddingTimeInterval:60 * 60 *24]]) {
        dayStr = @"yyyy-MM-dd,明天,HH:mm";
    } else if ([self isSameDay:[[NSDate date] dateByAddingTimeInterval:60 * 60 *24 *2]]) {
        dayStr = @"yyyy-MM-dd,后天,HH:mm";
    } else {
        dayStr = @"yyyy-MM-dd,EEEE,HH:mm";
    }
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:dayStr];
    NSString *dayDetail = [timeFormat stringFromDate:self];
    NSString *subStr = [dayDetail substringFromIndex:11];
    NSString *comPareStr = [subStr substringToIndex:[subStr length] - 6];
    if ([comPareStr isEqualToString:@"Monday"]) {
        dayDetail = [dayDetail stringByReplacingOccurrencesOfString:comPareStr withString:@"周一"];
    } else if ([comPareStr isEqualToString:@"Tuesday"]) {
        dayDetail = [dayDetail stringByReplacingOccurrencesOfString:comPareStr withString:@"周二"];
    } else if ([comPareStr isEqualToString:@"Wednesday"]) {
        dayDetail = [dayDetail stringByReplacingOccurrencesOfString:comPareStr withString:@"周三"];
    } else if ([comPareStr isEqualToString:@"Thursday"]) {
        dayDetail = [dayDetail stringByReplacingOccurrencesOfString:comPareStr withString:@"周四"];
    } else if ([comPareStr isEqualToString:@"Friday"]) {
        dayDetail = [dayDetail stringByReplacingOccurrencesOfString:comPareStr withString:@"周五"];
    } else if ([comPareStr isEqualToString:@"Saturday"]) {
        dayDetail = [dayDetail stringByReplacingOccurrencesOfString:comPareStr withString:@"周六"];
    } else if ([comPareStr isEqualToString:@"Sunday"]) {
        dayDetail = [dayDetail stringByReplacingOccurrencesOfString:comPareStr withString:@"周日"];
    }
    return dayDetail;
}

- (NSDate *)localTimeDate
{
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    long timeOffset = [nowTimeZone secondsFromGMTForDate:self];
    NSDate *newDate = [self dateByAddingTimeInterval:timeOffset];
    return newDate;
}
- (NSUInteger)year
{
	return [[NSCalendar currentCalendar] ordinalityOfUnit:NSYearCalendarUnit inUnit:NSEraCalendarUnit forDate:self];
}

- (NSUInteger)month
{
	return [[NSCalendar currentCalendar] ordinalityOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
}

- (NSUInteger)monthday
{
	return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
}
- (BOOL)isSameDay:(NSDate *)date
{
    if (date == nil) {
        return NO;
    }
    return ([self year] == [date year]) && ([self month] == [date month]) && ([self monthday] == [date monthday]);
}
@end

@implementation NSDate (CALENDAR)
- (NSDate *)cc_dateByMovingToBeginningOfDay:(NSCalendar *)calendar
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [calendar components:flags fromDate:self];
    [parts setHour:0];
    [parts setMinute:0];
    [parts setSecond:0];
    return [calendar dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToEndOfDay:(NSCalendar *)calendar
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [calendar components:flags fromDate:self];
    [parts setHour:23];
    [parts setMinute:59];
    [parts setSecond:59];
    return [calendar dateFromComponents:parts];
}
//上一天
- (NSDate *)cc_dateByMovingToThePreviousDay:(NSCalendar *)calendar
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = -1;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToBeginningOfDay:calendar];
}

//下一天
- (NSDate *)cc_dateByMovingToTheFollowingDay:(NSCalendar *)calendar
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = 1;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToBeginningOfDay:calendar];
}

//某天
- (NSDate *)cc_dateByMovingToDay:(NSInteger)day calendar:(NSCalendar *)calendar
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = day;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToBeginningOfDay:calendar];
}

//本年第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheYear:(NSCalendar *)calendar
{
    NSDate *d = nil;
    BOOL ok = [calendar rangeOfUnit:NSYearCalendarUnit startDate:&d interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day the month based on %@", self);
    return d;
}
//本星期最后一天
- (NSDate *)cc_dateByMovingToLastDayOfTheYear:(NSCalendar *)calendar
{
    return [[self cc_dateByMovingToFirstDayOfTheFollowingYear:calendar] cc_dateByMovingToLastSecond:calendar];
}
//上一年第一天
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousYear:(NSCalendar *)calendar
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = -1;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheYear:calendar];
}

//下一年第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingYear:(NSCalendar *)calendar
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = 1;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheYear:calendar];
}

//某年第一天
- (NSDate *)cc_dateByMovingToFirstDayOfYear:(NSInteger)year calendar:(NSCalendar *)calendar
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = year;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheYear:calendar];
}

//本月第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth:(NSCalendar *)calendar
{
    NSDate *d = nil;
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&d interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day the month based on %@", self);
    return d;
}
//本月最后一天
- (NSDate *)cc_dateByMovingToLastDayOfTheMonth:(NSCalendar *)calendar
{
    return [[self cc_dateByMovingToFirstDayOfTheFollowingMonth:calendar] cc_dateByMovingToLastSecond:calendar];
}

//上一月第一天
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth:(NSCalendar *)calendar
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.month = -1;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth:calendar];
}
//上月最后一天
- (NSDate *)cc_dateByMovingToLastDayOfLastMonth:(NSCalendar *)calendar
{
    return [[self cc_dateByMovingToFirstDayOfTheMonth:calendar] cc_dateByMovingToLastSecond:calendar];
}
//下一月第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth:(NSCalendar *)calendar
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.month = 1;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth:calendar];
}
//某月第一天
- (NSDate *)cc_dateByMovingToFirstDayOfMonth:(NSInteger)month calendar:(NSCalendar *)calendar;
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.month = month;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth:calendar];
}

//本星期第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheWeek:(NSCalendar *)calendar
{
    NSDate *d = nil;
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&d interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day the week based on %@", self);
    return d;
}
//本星期最后一天
- (NSDate *)cc_dateByMovingToLastDayOfTheWeek:(NSCalendar *)calendar
{
    return [[self cc_dateByMovingToFirstDayOfTheFollowingWeek:calendar] cc_dateByMovingToLastSecond:calendar];
}
//上星期第一天
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousWeek:(NSCalendar *)calendar
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.week = -1;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheWeek:calendar];
}
//下星期第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingWeek:(NSCalendar *)calendar
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.week = 1;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheWeek:calendar];
}

//某星期第一天
- (NSDate *)cc_dateByMovingToFirstDayOfWeek:(NSInteger)week calendar:(NSCalendar *)calendar;
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.week = week;
    return [[calendar dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheWeek:calendar];
}

//前一秒钟
- (NSDate *)cc_dateByMovingToLastSecond:(NSCalendar *)calendar
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.second = -1;
    return [calendar dateByAddingComponents:c toDate:self options:0];
}

- (NSDateComponents *)cc_componentsForMonthDayAndYear:(NSCalendar *)calendar
{
    return [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}

- (NSUInteger)cc_weekday:(NSCalendar *)calendar
{
    return [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSUInteger)cc_monthday:(NSCalendar *)calendar
{
    return [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
}

- (NSUInteger)cc_year:(NSCalendar *)calendar
{
    return [calendar ordinalityOfUnit:NSYearCalendarUnit inUnit:NSEraCalendarUnit forDate:self];
}

- (NSUInteger)cc_month:(NSCalendar *)calendar
{
    return [calendar ordinalityOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
}

- (NSUInteger)cc_numberOfDaysInMonth:(NSCalendar *)calendar
{
    return [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

- (NSUInteger)cc_numberOfDaysFromDate:(NSDate *)date calendar:(NSCalendar *)calendar
{
    NSDateComponents *c = [calendar components:NSDayCalendarUnit
                                      fromDate:[date cc_dateByMovingToBeginningOfDay:calendar]
                                        toDate:[self cc_dateByMovingToTheFollowingDay:calendar]
                                       options:0];
    return [c day];
}

- (NSUInteger)cc_numberOfWeeksFromDate:(NSDate *)date calendar:(NSCalendar *)calendar
{
    NSDateComponents *c = [calendar components:NSWeekCalendarUnit
                                      fromDate:[date cc_dateByMovingToFirstDayOfTheWeek:calendar]
                                        toDate:[self cc_dateByMovingToFirstDayOfTheFollowingWeek:calendar]
                                       options:0];
    return [c week];
}

- (NSUInteger)cc_numberOfMonthsFromDate:(NSDate *)date calendar:(NSCalendar *)calendar
{
    NSDateComponents *c = [calendar components:NSMonthCalendarUnit
                                      fromDate:[date cc_dateByMovingToFirstDayOfTheMonth:calendar]
                                        toDate:[self cc_dateByMovingToFirstDayOfTheFollowingMonth:calendar]
                                       options:0];
    return [c month];
}

- (NSUInteger)cc_numberOfYearsFromDate:(NSDate *)date calendar:(NSCalendar *)calendar
{
    NSDateComponents *c = [calendar components:NSYearCalendarUnit
                                      fromDate:[date cc_dateByMovingToFirstDayOfTheYear:calendar]
                                        toDate:[self cc_dateByMovingToFirstDayOfTheFollowingYear:calendar]
                                       options:0];
    return [c year];
}

@end
