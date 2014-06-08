//
//  PushNotificationSettingViewController.m
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "PushNotificationSettingViewController.h"
#import "UITableView+Additions.h"
#import "UserNotificationSettingClient.h"
#import "UserNotificationSettingCell.h"

@interface PushNotificationSettingViewController() <UserNotificationSettingCellDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UserNotificationSettingClient *userNotificationSettingClient;
@property (nonatomic, strong) NSArray *userNotificationSettings;

@end

@implementation PushNotificationSettingViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showLoader];
    
    [self.userNotificationSettingClient fetchUserNotificationSettingsWithCompletion:^(NSArray *userNotificationSettings, NSError *error) {
        
        [self hideLoader];
        
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"Error reading notification settings"];
        }
        else
        {
            self.userNotificationSettings = userNotificationSettings;
            [self.tableView deleteRowsAndAnimateNewRowsInSectionZero:userNotificationSettings.count];
        }
    }];
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userNotificationSettings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UserNotificationSettingCell";
    UserNotificationSetting *setting = [self.userNotificationSettings objectAtIndex:indexPath.row];
    UserNotificationSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setUserNotificationSetting:setting];
    [cell setDelegate:self];
    
    return cell;
}

#pragma mark - UserNotificationSettingCellDelegate -

- (void)userNotificationSettingCell:(UserNotificationSettingCell *)cell didSwitchNotificationSetting:(BOOL)enabled
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    UserNotificationSetting *setting = [self.userNotificationSettings objectAtIndex:indexPath.row];
    setting.enabled = @(enabled);
    
    [self.userNotificationSettingClient saveUserNotificationSetting:setting];
}

#pragma mark - Setter & Getter -

- (UserNotificationSettingClient *)userNotificationSettingClient
{
    if (!_userNotificationSettingClient)
    {
        _userNotificationSettingClient = [[UserNotificationSettingClient alloc] init];
    }
    
    return _userNotificationSettingClient;
}

@end
