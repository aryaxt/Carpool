//
//  UserNotificationSettingClient.m
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "UserNotificationSettingClient.h"

@implementation UserNotificationSettingClient

- (void)fetchUserNotificationSettingsWithCompletion:(void (^) (NSArray *userNotificationSettings, NSError *error))completion
{
    [PFCloud callFunctionInBackground:@"UserNotificationSetting"
                       withParameters:@{}
                                block:^(id objects, NSError *error) {
                                    if (error)
                                    {
                                        completion(nil, error);
                                    }
                                    else
                                    {
                                        NSMutableArray *userSettings = [NSMutableArray array];
                                        
                                        for (PFObject *object in objects)
                                        {
                                            [userSettings addObject:(UserNotificationSetting *)object];
                                        }
                                        
                                        completion(userSettings, nil);
                                    }
                                }];
}

- (void)saveUserNotificationSetting:(UserNotificationSetting *)userNotificationSetting
{
    [userNotificationSetting saveEventually];
}

@end
