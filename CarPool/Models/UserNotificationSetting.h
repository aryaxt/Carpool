//
//  UserNotificationSetting.h
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "NotificationSetting.h"

@interface UserNotificationSetting : PFObject<PFSubclassing>

@property (nonatomic, strong) NotificationSetting *notificationSetting;
@property (nonatomic, strong) NSNumber *enabled;

@end
