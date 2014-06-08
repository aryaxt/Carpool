//
//  PersonalMessagesViewController.h
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "PushNotificationManager.h"

@interface PersonalMessagesViewController : BaseViewController <PushNotificationHandler>

@property (nonatomic, strong) User *user;

@end
