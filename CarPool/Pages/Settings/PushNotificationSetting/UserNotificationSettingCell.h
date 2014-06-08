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

- (void)setUserNotificationSetting:(UserNotificationSetting *)setting;

@property (nonatomic, weak) id <UserNotificationSettingCellDelegate> delegate;

@end
