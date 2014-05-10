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

@interface MyOffersViewController : BaseViewController <SlideNavigationControllerDelegate, MyOfferCellDelegate, CreateOfferViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *offers;
@property (nonatomic, strong) CarPoolOfferClient *offerClient;
@property (nonatomic, strong) NSIndexPath *indexPathForExpandedCell;

@end
