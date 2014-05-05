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
@dynamic time;
@dynamic user;
@dynamic period;
@dynamic startLocation;
@dynamic endLocation;
@dynamic message;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

+ (void)load
{
    [self registerSubclass];
}

@end
