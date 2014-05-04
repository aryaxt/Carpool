//
//  CarPoolOffer.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "Period.h"

@interface CarPoolOffer : PFObject<PFSubclassing>

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) PFGeoPoint *startPoint;
@property (nonatomic, strong) PFGeoPoint *endPoint;
@property (nonatomic, strong, readonly) PFRelation *user;
@property (nonatomic, strong, readonly) PFRelation *period;

@end
