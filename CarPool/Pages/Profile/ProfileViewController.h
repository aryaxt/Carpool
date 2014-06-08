//
//  ProfileViewController.h
//  CarPool
//
//  Created by Aryan on 5/18/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"

@interface ProfileViewController : BaseViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) BOOL shouldEnableSlideMenu;

@end
