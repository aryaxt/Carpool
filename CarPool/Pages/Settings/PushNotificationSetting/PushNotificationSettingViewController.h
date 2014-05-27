//
//  PushNotificationSettingViewController.h
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "UserNotificationSettingClient.h"
#import "UserNotificationSettingCell.h"

@interface PushNotificationSettingViewController : BaseViewController <UserNotificationSettingCellDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UserNotificationSettingClient *userNotificationSettingClient;
@property (nonatomic, strong) NSArray *userNotificationSettings;

@end
