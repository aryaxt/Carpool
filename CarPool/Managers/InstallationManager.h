//
//  InstallationManager.h
//  CarPool
//
//  Created by Aryan on 5/13/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Installation.h"

@interface InstallationManager : NSObject

+ (InstallationManager *)sharedInstance;
- (void)registerDeviceTokenWithParse;

@property (nonatomic, strong) NSData *deviceToken;

@end
