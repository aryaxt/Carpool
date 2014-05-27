//
//  UserNotificationSettingClient.h
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserNotificationSetting.h"

@interface UserNotificationSettingClient : NSObject

- (void)saveUserNotificationSetting:(UserNotificationSetting *)userNotificationSetting;
- (void)fetchUserNotificationSettingsWithCompletion:(void (^) (NSArray *userNotificationSettings, NSError *error))completion;

@end
