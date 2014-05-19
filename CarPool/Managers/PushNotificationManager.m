//
//  InstallationManager.m
//  CarPool
//
//  Created by Aryan on 5/13/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "PushNotificationManager.h"
#import "SlideNavigationController.h"

@implementation PushNotificationManager

NSString *PushNotificationTypeComment = @"comment";

#pragma mark - Initialization -

+ (PushNotificationManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static PushNotificationManager *singleton;
    
    dispatch_once(&onceToken, ^{
        singleton = [[PushNotificationManager alloc] init];
    });
    
    return singleton;
}

#pragma mark - Public Methods -

- (void)handlePushNotification:(NSDictionary *)userInfo
{
    NSDictionary *data = [userInfo objectForKey:@"data"];
    NSString *type = [data objectForKey:@"type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:type object:data];
}

- (void)registerDeviceWithParse
{
    if (self.deviceToken)
    {
        Installation *currentInstallation = [Installation currentInstallation];
        [currentInstallation setDeviceTokenFromData:self.deviceToken];
        [currentInstallation setUser:[User currentUser]];
        [currentInstallation saveInBackground];
    }
}

@end
