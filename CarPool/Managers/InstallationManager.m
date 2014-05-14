//
//  InstallationManager.m
//  CarPool
//
//  Created by Aryan on 5/13/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "InstallationManager.h"

@implementation InstallationManager

#pragma mark - Initialization -

+ (InstallationManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static InstallationManager *singleton;
    
    dispatch_once(&onceToken, ^{
        singleton = [[InstallationManager alloc] init];
    });
    
    return singleton;
}

#pragma mark - Public Methods -

- (void)registerDeviceTokenWithParse
{
    Installation *currentInstallation = [Installation currentInstallation];
    [currentInstallation setDeviceTokenFromData:self.deviceToken];
    [currentInstallation setUser:[User currentUser]];
    [currentInstallation saveInBackground];
}

@end
