//
//  PushNotificationSetting.m
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "NotificationSetting.h"
#import <Parse/PFObject+Subclass.h>

@implementation NotificationSetting
@dynamic name;
@dynamic detail;
@dynamic defaultValue;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

+ (void)load
{
    [self registerSubclass];
}

@end
