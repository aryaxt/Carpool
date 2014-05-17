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

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) User *from;
@property (nonatomic, strong) User *to;
@property (nonatomic, strong) Location *startLocation;
@property (nonatomic, strong) Location *endLocation;
@property (nonatomic, strong) CarPoolOffer *offer;
@property (nonatomic, strong, readonly) PFRelation *comments;

@end
