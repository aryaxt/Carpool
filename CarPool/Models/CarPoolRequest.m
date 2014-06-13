//
//  CarPoolRequest.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CarPoolRequest.h"
#import <Parse/PFObject+Subclass.h>

@implementation CarPoolRequest
@dynamic date;
@dynamic status;
@dynamic comments;
@dynamic message;
@dynamic period;
@dynamic from;
@dynamic to;
@dynamic offer;
@dynamic startLocation;
@dynamic endLocation;

NSNumber *CarPoolRequestPeriodOneTime;
NSNumber *CarPoolRequestPeriodWeekDays;
NSString *CarPoolRequestStatusAccepted = @"accepted";
NSString *CarPoolRequestStatusRejected = @"rejected";
NSString *CarPoolRequestStatusCanceled = @"canceled";

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

+ (void)load
{
    [self registerSubclass];
    
    CarPoolRequestPeriodOneTime = @1;
    CarPoolRequestPeriodWeekDays = @5;
}

@end
