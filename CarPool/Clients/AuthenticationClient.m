//
//  AuthenticationClient.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "AuthenticationClient.h"

@implementation AuthenticationClient

- (void)authenticateUsingFacebookWithCompletion:(void (^)(PFUser *user, NSError *error))completion
{
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    [PFFacebookUtils initializeFacebook];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user)
        {
            completion(nil, error);
        }
        else
        {
            FBRequest *request = [FBRequest requestForMe];
            
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary *userData = (NSDictionary *)result;
                    
                    NSString *photoUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userData[@"id"]];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                    NSDate *birthDay = [dateFormatter dateFromString:userData[@"birthday"]];
                    
                    PFUser *user = [PFUser currentUser];
                    [user setValue:userData[@"name"] forKey:@"name"];
                    [user setValue:birthDay forKey:@"birthday"];
                    [user setValue:userData[@"gender"] forKey:@"gender"];
                    [user setValue:photoUrl forKey:@"photoUrl"];
                    
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        completion(user, nil);
                    }];
                }
            }];
        }
    }];
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
            andCompletion:(void (^)(PFUser *user, NSError *error))completion
{
    [PFUser logInWithUsernameInBackground:username
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        completion(user, error);
                                    }];
}

@end
