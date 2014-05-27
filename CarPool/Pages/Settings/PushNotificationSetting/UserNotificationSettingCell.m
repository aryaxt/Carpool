//
//  UserNotificationSettingCell.m
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "UserNotificationSettingCell.h"

@implementation UserNotificationSettingCell

#pragma mark - Public MEthods -

- (void)setUserNotificationSetting:(UserNotificationSetting *)setting
{
    self.lblTitle.text = setting.notificationSetting.name;
    self.notificationSwitch.on = setting.enabled.boolValue;
}

#pragma mark - IBActions -

- (IBAction)switchDidChange:(id)sender
{
    [self.delegate userNotificationSettingCell:self didSwitchNotificationSetting:self.notificationSwitch.isOn];
}

@end
