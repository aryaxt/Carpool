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

#pragma - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma - Public Methods -

- (void)showLoader
{
    [self.progressHud show:YES];
}

- (void)hideLoader
{
    [self.progressHud hide:YES];
}

#pragma - Setter & Getter -

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
