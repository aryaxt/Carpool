//
//  InstallationManager.h
//  CarPool
//
//  Created by Aryan on 5/13/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Installation.h"

@protocol PushNotificationHandler <NSObject>
- (BOOL)canHandlePushNotificationWithType:(NSString *)type andData:(NSDictionary *)data;
@end

@interface PushNotificationManager : NSObject

extern NSString *PushNotificationTypeComment;

@property (nonatomic, strong) NSData *deviceToken;

+ (PushNotificationManager *)sharedInstance;
- (void)registerDeviceWithParse;
- (void)handlePushNotification:(NSDictionary *)userInfo;

@end
