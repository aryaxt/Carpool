//
//  MyRequestsViewController.h
//  CarPool
//
//  Created by Aryan on 5/28/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CarPoolRequestClient.h"
#import "MyRequestCell.h"
#import "UITableView+Additions.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "RequestDetailViewController.h"
#import "UIViewController+Additions.h"

@interface MyRequestsViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *requests;
@property (nonatomic, strong) CarPoolRequestClient *requestclient;

- (void)addNewRequest:(CarPoolRequest *)request;

@end
