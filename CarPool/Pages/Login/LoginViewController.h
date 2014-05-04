//
//  LoginViewController.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationClient.h"
#import "BaseViewController.h"
#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController : PFLogInViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end
