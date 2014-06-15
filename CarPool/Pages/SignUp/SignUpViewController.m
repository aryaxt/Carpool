//
//  SignUpViewController.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "SignUpViewController.h"
#import "GoogleAnalyticsManager.h"

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[GoogleAnalyticsManager sharedInstance] trackPage:GoogleAnalyticsManagerPageSignup];
    
    self.signUpView.logo = nil;
}

@end
