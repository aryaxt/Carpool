//
//  Profile.m
//  CarPool
//
//  Created by Aryan on 5/18/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "Profile.h"
#import <Parse/PFObject+Subclass.h>

@implementation Profile

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

+ (void)load
{
    [self registerSubclass];
}

@end
