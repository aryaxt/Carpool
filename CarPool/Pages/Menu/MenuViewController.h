//
//  MenuViewController.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "UIImageView+Additions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MenuViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIImageView *imgProfilePhoto;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
