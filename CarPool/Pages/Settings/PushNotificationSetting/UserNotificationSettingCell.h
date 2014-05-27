//
//  UserNotificationSettingCell.h
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserNotificationSetting.h"

@class UserNotificationSettingCell;
@protocol UserNotificationSettingCellDelegate <NSObject>
- (void)userNotificationSettingCell:(UserNotificationSettingCell *)cell didSwitchNotificationSetting:(BOOL)enabled;
@end

@interface UserNotificationSettingCell : UITableViewCell

@property (nonatomic, weak) id <UserNotificationSettingCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UISwitch *notificationSwitch;

- (void)setUserNotificationSetting:(UserNotificationSetting *)setting;
- (IBAction)switchDidChange:(id)sender;

@end
