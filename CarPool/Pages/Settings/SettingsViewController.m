//
//  SettingsViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "SettingsViewController.h"
#import "PushNotificationSettingViewController.h"
#import "SlideNavigationController.h"

@interface SettingsViewController() <SlideNavigationControllerDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation SettingsViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self trackPage:GoogleAnalyticsManagerPageSettings];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Push Notification Settings";
            break;
            
        case 1:
            cell.textLabel.text = @"Privacy Settings";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self performSegueWithIdentifier:@"PushNotificationSettingViewController" sender:self];
            break;
            
        case 1:
            // Do stuff here
            break;
            
        default:
            break;
    }
}

@end
