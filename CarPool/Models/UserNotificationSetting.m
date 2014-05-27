//
//  UserNotificationSetting.m
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "UserNotificationSetting.h"
#import <Parse/PFObject+Subclass.h>

@implementation UserNotificationSetting
@dynamic notificationSetting;
@dynamic enabled;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

+ (void)load
{
    [self registerSubclass];
}

@end
