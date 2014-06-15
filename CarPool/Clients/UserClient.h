//
//  UserClient.h
//  CarPool
//
//  Created by Aryan on 6/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserClient : NSObject

- (void)saveUser:(User *)user withCompletion:(void (^)(NSError *error))completion;
- (void)blockUser:(User *)user withCompletion:(void (^)(NSError *error))completion;
- (void)unblockUser:(User *)user withCompletion:(void (^)(NSError *error))completion;
- (void)checkIsUserInMyBlockList:(User *)user withCompletion:(void (^)(NSNumber *blocked, NSError *error))completion;

@end
