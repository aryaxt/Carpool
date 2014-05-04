//
//  LoginViewController.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *txtUsername;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword;

- (IBAction)loginSelected:(id)sender;
- (IBAction)facebookLoginSelected:(id)sender;

@end
