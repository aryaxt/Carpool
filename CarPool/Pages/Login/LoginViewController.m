//
//  LoginViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "LoginViewController.h"
#import "PushNotificationManager.h"

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
    
    [PFFacebookUtils initializeFacebook];
    
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
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *photoUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userData[@"id"]];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            NSDate *birthDay = [dateFormatter dateFromString:userData[@"birthday"]];
            NSNumber *gender = [userData[@"gender"] isEqualToString:@"male"] ? @1 : @2;
            
            PFUser *user = [PFUser currentUser];
            [user setValue:userData[@"name"] forKey:@"name"];
            [user setValue:birthDay forKey:@"birthday"];
            [user setValue:gender forKey:@"gender"];
            [user setValue:photoUrl forKey:@"photoUrl"];
            
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self loginSucceeded];
            }];
        }
    }];
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
