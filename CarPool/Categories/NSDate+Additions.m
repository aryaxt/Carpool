//
//  NSDate+Additions.m
//  CarPool
//
//  Created by Aryan on 6/8/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

#pragma mark - Public -

+ (NSDate *)dateWithoutTimeComponents
{
    return [[NSDate date] dateWithoutTimeComponents];
}

- (NSDate *)dateWithoutTimeComponents
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    return [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
}

- (NSDate *)dateByCopyingTimeComponentsFromDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *priorComponents = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:date];
    
    NSDateComponents *newComponents = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    
    [newComponents setSecond:[priorComponents second]];
    [newComponents setMinute:[priorComponents minute]];
    [newComponents setHour:[priorComponents hour]];
    
    return [cal dateFromComponents:newComponents];
}

- (NSInteger)day
{
    return self.components.day;
}

- (NSInteger)month
{
    return self.components.month;
}

- (NSInteger)year
{
    return self.components.year;
}

- (NSInteger)weekDay
{
    return self.components.weekday;
}

- (NSInteger)numberOfDaysInMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    return rng.length;
}

- (NSDate *)firstDayInMonth
{
    NSDateComponents *components = self.components;
    components.day = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)firstDayOfNextMonth
{
    NSDateComponents *components = self.components;
    components.day = 1;
    components.year = (components.month == 12) ? components.year+1 : components.year;
    components.month = (components.month == 12) ? 1 : components.month+1;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)firstDayOfLastMonth
{
    NSDateComponents *components = self.components;
    components.day = 1;
    components.year = (components.month == 1) ? components.year-1 : components.year;
    components.month = (components.month == 1) ? 12 : components.month-1;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    return [self dateByAddingTimeInterval:60*60*24*days];
}

- (BOOL)isTheSameDayAs:(NSDate *)date
{
    return (self.day == date.day && self.month == date.month && self.year == date.year);
}

#pragma mark - Private -

- (NSDateComponents *)components
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:self];
}

@end
