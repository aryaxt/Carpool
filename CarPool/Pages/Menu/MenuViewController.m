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
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "InboxViewController.h"
#import "MyActivitiesViewController.h"
#import <Parse/Parse.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation MenuViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.layer.borderWidth = 1;
    
    self.topView.layer.borderWidth = .6;
    self.topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.lblName.text = [User currentUser].name;
    [self.imgProfilePhoto setUserPhotoStyle];
    [self.imgProfilePhoto setImageWithURL:[NSURL URLWithString:[User currentUser].photoUrl]];
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    switch (indexPath.row) {
        case 0:
        cell.textLabel.text = @"Home";
        break;
        
        case 1:
        cell.textLabel.text = @"My Activities";
        break;
            
        case 2:
            cell.textLabel.text = @"Inbox";
            break;
        
        case 3:
        cell.textLabel.text = @"Profile";
        break;
        
        case 4:
        cell.textLabel.text = @"Settings";
        break;
        
        case 5:
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
    
    switch (indexPath.row)
    {
        case 0:
        viewContorller = [HomeViewController viewController];
        break;
        
        case 1:
        viewContorller = [MyActivitiesViewController viewController];
        break;
            
        case 2:
            viewContorller = [InboxViewController viewController];
            break;
        
        case 3:
        {
            ProfileViewController *vc = [ProfileViewController viewController];
            vc.user = [User currentUser];
            viewContorller = vc;
        }
        break;
        
        case 4:
        viewContorller = [SettingsViewController viewController];
        break;
        
        case 5:
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
