//
//  AuthenticationClient.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AuthenticationClient : NSObject

- (void)authenticateUsingFacebookWithCompletion:(void (^)(PFUser *user, NSError *error))completion;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
            andCompletion:(void (^)(PFUser *user, NSError *error))completion;

@end
