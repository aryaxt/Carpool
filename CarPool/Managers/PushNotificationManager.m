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
    
    BOOL canViewControllerHandleNotification = NO;
    UIViewController *vc = [SlideNavigationController sharedInstance].topViewController;
    
    if ([vc conformsToProtocol:@protocol(PushNotificationHandler)])
    {
        canViewControllerHandleNotification = [(id <PushNotificationHandler>)vc canHandlePushNotificationWithType:type andData:data];
    }
    
    if (!canViewControllerHandleNotification)
    {
        //TODO: Do something smarter here
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PushNotification"
                                                        message:@"Fix me"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
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
