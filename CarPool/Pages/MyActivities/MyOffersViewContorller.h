//
//  OffersViewContorller.h
//  CarPool
//
//  Created by Aryan on 5/28/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CarPoolOfferClient.h"
#import "MyOfferCell.h"
#import "UITableView+Additions.h"
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface MyOffersViewContorller : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *offers;
@property (nonatomic, strong) CarPoolOfferClient *offerClient;

- (void)addNewOffer:(CarPoolOffer *)offer;

@end
