//
//  BaseViewController.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface BaseViewController()
@property (nonatomic, strong) MBProgressHUD *progressHud;
@end

@implementation BaseViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Public Methods -

- (void)alertWithtitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showLoader
{
    [self.progressHud show:YES];
}

- (void)hideLoader
{
    [self.progressHud hide:YES];
}

#pragma mark - Setter & Getter -

- (MBProgressHUD *)progressHud
{
    if (!_progressHud)
    {
        _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHud];
    }
    
    return _progressHud;
}

@end
