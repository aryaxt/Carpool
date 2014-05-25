//
//  ApplicationVersion.m
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ApplicationVersion.h"
#import <Parse/PFObject+Subclass.h>

@implementation ApplicationVersion
@dynamic version;
@dynamic lastRequiredVersion;
@dynamic platform;
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
