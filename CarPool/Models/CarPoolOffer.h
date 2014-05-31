//
//  CarPoolOffer.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Location.h"

@interface CarPoolOffer : PFObject<PFSubclassing>

extern NSNumber *CarPoolOfferPeriodOneTime;
extern NSNumber *CarPoolOfferPeriodWeekDays;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *preferredGender;
@property (nonatomic, strong) NSNumber *minAge;
@property (nonatomic, strong) NSNumber *maxage;
@property (nonatomic, strong) NSNumber *period;
@property (nonatomic, strong) Location *startLocation;
@property (nonatomic, strong) Location *endLocation;
@property (nonatomic, strong) User *from;

@end
