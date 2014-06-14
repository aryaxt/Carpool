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
#import "CommentClient.h"

@interface MenuViewController()
@property (nonatomic, strong) CommentClient *commentClient;
@property (nonatomic, strong) NSNumber *unreadCommentCount;
@end

@implementation MenuViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topView.layer.borderWidth = .6;
    self.topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.lblName.text = [User currentUser].name;
    [self.imgProfilePhoto setUserPhotoStyle];
    [self.imgProfilePhoto setImageWithURL:[NSURL URLWithString:[User currentUser].photoUrl] placeholderImage:[UIImage imageNamed:USER_PHOTO_PLACEHOLDER]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
        [self fetchAndPopulateUnreadCommentCount];
    }];
    
    [self fetchAndPopulateUnreadCommentCount];
}

#pragma mark - Private Methods -

- (void)fetchAndPopulateUnreadCommentCount
{
    [self.commentClient fetchUnreadCommentCountWithCompletion:^(NSNumber *unreadCommentCount, NSError *error) {
        if (!error)
        {
            if (unreadCommentCount.intValue > self.unreadCommentCount.intValue && ![[SlideNavigationController sharedInstance] isMenuOpen])
            {
                [[SlideNavigationController sharedInstance] bounceMenu:MenuLeft withCompletion:nil];
            }
            
            self.unreadCommentCount = unreadCommentCount;
            [self.tableView reloadData];
        }
    }];
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
            cell.textLabel.text = (self.unreadCommentCount.intValue)
                ? [NSString stringWithFormat:@"Inbox (%@)", self.unreadCommentCount]
                : @"Inbox";
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

#pragma mark - Setter & Gettr -

- (CommentClient *)commentClient
{
    if (!_commentClient)
    {
        _commentClient = [[CommentClient alloc] init];
    }
    
    return _commentClient;
}
    

@end
