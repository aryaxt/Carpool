//
//  NSDate+Additions.m
//  CarPool
//
//  Created by Aryan on 6/8/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSDate *)dateWithoutTimeComponents
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    return [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
}

+ (NSDate *)dateWithoutTimeComponents
{
    return [[NSDate date] dateWithoutTimeComponents];
}

@end
