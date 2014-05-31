//
//  CarPoolOffer.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CarPoolOffer.h"
#import <Parse/PFObject+Subclass.h>

@implementation CarPoolOffer
@dynamic date;
@dynamic period;
@dynamic from;
@dynamic preferredGender;
@dynamic startLocation;
@dynamic endLocation;
@dynamic message;
@dynamic minAge;
@dynamic maxage;

NSNumber *CarPoolOfferPeriodOneTime;
NSNumber *CarPoolOfferPeriodWeekDays;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

+ (void)load
{
    [self registerSubclass];
    
    CarPoolOfferPeriodOneTime = @1;
    CarPoolOfferPeriodWeekDays = @5;
}

@end
