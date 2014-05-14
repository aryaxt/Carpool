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
@dynamic status;
@dynamic message;
@dynamic from;
@dynamic offer;
@dynamic startLocation;
@dynamic endLocation;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

+ (void)load
{
    [self registerSubclass];
}

@end
