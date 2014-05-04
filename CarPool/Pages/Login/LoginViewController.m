//
//  LoginViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@implementation LoginViewController

#pragma - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        [self loginSuccess];
    }
}

#pragma - IBActions -

- (IBAction)loginSelected:(id)sender
{
    [PFUser logInWithUsernameInBackground:self.txtUsername.text
                                 password:self.txtPassword.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (error)
                                        {
                                            //show error
                                        }
                                        else
                                        {
                                            [self loginSuccess];
                                        }
    }];
}

- (IBAction)facebookLoginSelected:(id)sender
{
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    [PFFacebookUtils initializeFacebook];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user)
        {
            if (!error)
            {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else
            {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        }
        else
        {
            FBRequest *request = [FBRequest requestForMe];
            
            // Send request to Facebook
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // result is a dictionary with the user's Facebook data
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
                        if (succeeded)
                        {
                            [self loginSuccess];
                        }
                        else
                        {
                            NSLog(@"failed to save user");
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)loginSuccess
{
    [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
}

@end
