//
//  MyOffersViewController.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "CarPoolOffer.h"
#import "CarPoolOfferClient.h"
#import "BaseViewController.h"
#import "SVPullToRefresh.h"
#import "UITableView+Additions.h"
#import "MyOfferCell.h"
#import "UIAlertView+Blocks.h"
#import "CreateOfferViewController.h"
#import "CarPoolRequestClient.h"
#import "MyRequestCell.h"
#import "RequestDetailViewController.h"
#import "UIViewController+Additions.h"

@interface MyActivitiesViewController : BaseViewController <SlideNavigationControllerDelegate, MyOfferCellDelegate, CreateOfferViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *btnAddOffer;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *offers;
@property (nonatomic, strong) NSMutableArray *requests;
@property (nonatomic, strong) CarPoolOfferClient *offerClient;
@property (nonatomic, strong) CarPoolRequestClient *requestclient;

- (IBAction)segmentedControlDidChange:(id)sender;

@end
