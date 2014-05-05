//
//  CarPoolRequest.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Parse/Parse.h>
#import "Location.h"

@interface CarPoolRequest : PFObject <PFSubclassing>

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) Location *startLocation;
@property (nonatomic, strong) Location *endLocation;
@property (nonatomic, strong, readonly) PFRelation *offer;

@end
