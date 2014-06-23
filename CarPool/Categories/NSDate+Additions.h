//
//  NSDate+Additions.h
//  CarPool
//
//  Created by Aryan on 6/8/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+ (NSDate *)dateWithoutTimeComponents;
- (NSDate *)dateWithoutTimeComponents;
- (NSDate *)dateByCopyingTimeComponentsFromDate:(NSDate *)dat;
- (NSInteger)day;
- (NSInteger)month;
- (NSInteger)year;
- (NSInteger)weekDay;
- (NSInteger)numberOfDaysInMonth;
- (NSDate *)firstDayInMonth;
- (NSDate *)firstDayOfNextMonth;
- (NSDate *)firstDayOfLastMonth;
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (BOOL)isTheSameDayAs:(NSDate *)date;
- (BOOL)isWeekend;

@end
