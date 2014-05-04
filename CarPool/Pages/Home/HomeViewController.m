//
//  HomeViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "HomeViewController.h"
#import "CarPoolOffer.h"

@implementation HomeViewController

#pragma - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
