//
//  ApplicationVersionClient.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationVersion.h"

@interface ApplicationVersionClient : NSObject

- (void)fetchLatestByPlatform:(NSString *)platform andCompletion:(void (^)(ApplicationVersion *applicationVersion, NSError *error))completion;

@end
