//
//  MenuViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MenuViewController.h"
#import "SlideNavigationController.h"
#import "UIViewController+Additions.h"
#import "MyOffersViewController.h"
#import "MyRequestsViewController.h"
#import "HomeViewController.h"
#import "AccountViewController.h"
#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation MenuViewController

#pragma - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    switch (indexPath.row) {
        case 0:
        cell.textLabel.text = [PFUser currentUser][@"name"];
        [cell.imageView setImageWithURL:[NSURL URLWithString:[PFUser currentUser][@"photoUrl"]]];
        break;
        
        case 1:
        cell.textLabel.text = @"Home";
        break;
        
        case 2:
        cell.textLabel.text = @"My Offers";
        break;
        
        case 3:
        cell.textLabel.text = @"My Requests";
        break;
        
        case 4:
        cell.textLabel.text = @"Account";
        break;
        
        case 5:
        cell.textLabel.text = @"Settings";
        break;
        
        case 6:
        cell.textLabel.text = @"Sign Out";
        break;
        
        default:
        break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewContorller;
    
    switch (indexPath.row) {
        case 1:
        viewContorller = [HomeViewController viewController];
        break;
        
        case 2:
        viewContorller = [MyOffersViewController viewController];
        break;
        
        case 3:
        viewContorller = [MyRequestsViewController viewController];
        break;
        
        case 4:
        viewContorller = [AccountViewController viewController];
        break;
        
        case 5:
        viewContorller = [SettingsViewController viewController];
        break;
        
        case 6:
        [PFUser logOut];
        [[PFFacebookUtils session] closeAndClearTokenInformation];
        [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
        return;
        break;
    }
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewContorller
                                                                    withCompletion:nil];
}

@end
