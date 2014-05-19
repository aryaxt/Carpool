//
//  User.m
//  CarPool
//
//  Created by Aryan on 5/9/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>

@implementation User
@dynamic username;
@dynamic name;
@dynamic gender;
@dynamic photoUrl;
@dynamic friends;
@dynamic blockedUsers;

+ (void)load
{
    [self registerSubclass];
}

@end
