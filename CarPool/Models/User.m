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
@dynamic dateOfBirth;
@dynamic profile;
@dynamic friends;
@dynamic blockedUsers;
@synthesize age;

+ (void)load
{
    [self registerSubclass];
}

- (NSNumber *)age
{
    NSDate *now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:self.dateOfBirth
                                       toDate:now
                                       options:0];
    
    return @([ageComponents year]);
}

@end
