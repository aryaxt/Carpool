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
        [self loginSucceeded];
    }
}

#pragma - IBActions -

- (IBAction)loginSelected:(id)sender
{
    [self showLoader];
    
    [self.authClient loginWithUsername:self.txtUsername.text
                              password:self.txtPassword.text
                         andCompletion:^(PFUser *user, NSError *error) {
                             [self hideLoader];
                             
                             if (error)
                             {
                                 //show error
                             }
                             else
                             {
                                 [self loginSucceeded];
                             }
    }];
}

- (IBAction)facebookLoginSelected:(id)sender
{
    [self showLoader];
    
    [self.authClient authenticateUsingFacebookWithCompletion:^(PFUser *user, NSError *error) {
        [self hideLoader];
        
        if (error)
        {
            // Display error
        }
        else if (user)
        {
            [self loginSucceeded];
        }
    }];
}

- (void)loginSucceeded
{
    [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
}

#pragma - Getter & Setter -

- (AuthenticationClient *)authClient
{
    if (!_authClient)
    {
        _authClient = [[AuthenticationClient alloc] init];
    }
    
    return _authClient;
}

@end
