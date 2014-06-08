//
//  RequestDetailViewController.h
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CarPoolRequest.h"
#import "PushNotificationManager.h"

@interface RequestDetailViewController : BaseViewController <PushNotificationHandler>

@property (nonatomic, strong) CarPoolRequest *request;

@end
