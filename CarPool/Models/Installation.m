//
//  Installation.m
//  CarPool
//
//  Created by Aryan on 5/13/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "Installation.h"
#import <Parse/PFObject+Subclass.h>

@implementation Installation
@dynamic user;

+ (void)load
{
    [self registerSubclass];
}

@end
