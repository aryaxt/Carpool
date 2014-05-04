//
//  CarPoolOffer.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Parse/Parse.h>
#import "Period.h"

@interface CarPoolOffer : PFObject<PFSubclassing>

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) PFGeoPoint *startPoint;
@property (nonatomic, strong) PFGeoPoint *endPoint;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) Period *period;

@end
