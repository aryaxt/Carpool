//
//  LoginViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "LoginViewController.h"
#import "PushNotificationManager.h"
#import "GoogleAnalyticsManager.h"

@implementation LoginViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.fields = PFLogInFieldsUsernameAndPassword
        | PFLogInFieldsFacebook
        | PFLogInFieldsTwitter
        | PFLogInFieldsPasswordForgotten
        | PFLogInFieldsSignUpButton;
        
        self.facebookPermissions = @[@"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[GoogleAnalyticsManager sharedInstance] trackPage:GoogleAnalyticsManagerPageLogin];
    
    [PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:@"MR6F0dYtUhcbhxry4ruQQJhiF" consumerSecret:@"oVtsA7BhAk2Iyt4x1we01euDKZ0Nip5MZ4HwfFUg9wmvi4qvGQ"];
    
    if ([PFUser currentUser] //&& // Check if a user is cached
        /*[PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]*/) // Check if user is linked to Facebook
    {
        [self loginSucceeded];
        return;
    }
    
    self.delegate = self;
    
    self.logInView.logo = nil;
    
    [self.logInView.signUpButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.logInView.signUpButton addTarget:self action:@selector(singUpSelected:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)singUpSelected:(id)sender
{
    SignUpViewController *vc = [[SignUpViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)loginSucceeded
{
    [[PushNotificationManager sharedInstance] registerDeviceWithParse];
    
    [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
}

#pragma mark - PFLogInViewControllerDelegate -

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        FBRequest *request = [FBRequest requestForMe];
        
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                NSDictionary *userData = (NSDictionary *)result;
                
                NSString *photoUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userData[@"id"]];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                NSDate *birthDay = [dateFormatter dateFromString:userData[@"birthday"]];
                NSNumber *gender = [userData[@"gender"] isEqualToString:@"male"] ? @1 : @2;
                
                User *user = [User currentUser];
                user.name = userData[@"name"];
                user.dateOfBirth = birthDay;
                user.gender = gender;
                user.photoUrl = photoUrl;
                
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [self loginSucceeded];
                }];
            }
        }];
    }
    else if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]])
    {
        User *user = [User currentUser];
        user.name = [PFTwitterUtils twitter].screenName;
    }
    else
    {
        [self loginSucceeded];
    }
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"");
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    NSLog(@"");
}

#pragma mark - PFSignUpViewControllerDelegate -

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:^{
       [self loginSucceeded]; 
    }];
}

@end
