//
//  UserClient.m
//  CarPool
//
//  Created by Aryan on 6/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "UserClient.h"

@implementation UserClient

- (void)saveUser:(User *)user withCompletion:(void (^)(NSError *error))completion
{
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(error);
    }];
}

- (void)checkIsUserInMyBlockList:(User *)user withCompletion:(void (^)(NSNumber *blocked, NSError *error))completion
{
    PFQuery *query = [User currentUser].blockedUsers.query;
    [query whereKey:@"objectId" equalTo:user.objectId];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            completion(number == 0 ? @NO : @YES, nil);
        }
    }];
}

- (void)blockUser:(User *)user withCompletion:(void (^)(NSError *error))completion
{
    User *currentUser = [User currentUser];
    [currentUser.blockedUsers addObject:user];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(error);
    }];
}

- (void)unblockUser:(User *)user withCompletion:(void (^)(NSError *error))completion
{
    User *currentUser = [User currentUser];
    [currentUser.blockedUsers removeObject:user];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(error);
    }];
}

@end
