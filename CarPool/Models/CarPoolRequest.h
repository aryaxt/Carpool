//
//  CarPoolRequest.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Parse/Parse.h>
#import "CarPoolOffer.h"
#import "Location.h"
#import "User.h"

@interface CarPoolRequest : PFObject <PFSubclassing>


extern NSNumber *CarPoolRequestPeriodOneTime;
extern NSNumber *CarPoolRequestPeriodWeekDays;
extern NSString *CarPoolRequestStatusAccepted;
extern NSString *CarPoolRequestStatusRejected;
extern NSString *CarPoolRequestStatusCanceled;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *period; /* Used for open requests */
@property (nonatomic, strong) User *from;
@property (nonatomic, strong) User *to;
@property (nonatomic, strong) Location *startLocation;
@property (nonatomic, strong) Location *endLocation;
@property (nonatomic, strong) CarPoolOffer *offer;
@property (nonatomic, strong, readonly) PFRelation *comments;

@end
