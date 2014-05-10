//
//  CarPoolOffer.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Period.h"
#import "Location.h"

@interface CarPoolOffer : PFObject<PFSubclassing>

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) Location *startLocation;
@property (nonatomic, strong) Location *endLocation;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Period *period;

@end
