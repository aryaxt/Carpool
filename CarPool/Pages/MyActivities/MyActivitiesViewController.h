//
//  MyOffersViewController.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "CreateOfferViewController.h"
#import "CreateRequestViewController.h"
#import "MyOffersViewContorller.h"
#import "MyRequestsViewController.h"
#import "UIViewController+Additions.h"

@interface MyActivitiesViewController : BaseViewController <SlideNavigationControllerDelegate, CreateOfferViewControllerDelegate, CreateRequestViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIBarButtonItem *btnAddOffer;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) MyOffersViewContorller *myOffersViewController;
@property (nonatomic, strong) MyRequestsViewController *myRequestsViewController;

- (IBAction)segmentedControlDidChange:(id)sender;
- (IBAction)createSeelcted:(id)sender;

@end
