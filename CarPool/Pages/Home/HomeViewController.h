//
//  HomeViewController.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SlideNavigationController.h"
#import "BaseViewController.h"
#import "CarPoolOfferClient.h"
#import "OfferDetailViewController.h"
#import "CreateRequestViewController.h"
#import "UIColor+Additions.h"
#import "CarPoolOffer.h"
#import "CarPoolRequest.h"
#import "LocationManager.h"
#import "UIViewController+Additions.h"
#import "CreateRequestViewController.h"
#import "SearchFilterViewController.h"
#import "SearchFilter.h"

@interface HomeViewController : BaseViewController <SlideNavigationControllerDelegate, MKMapViewDelegate, OfferDetailViewControllerDelegate, SearchFilterViewControllerDelegate>

@property (nonatomic, strong) CarPoolOfferClient *offerClient;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) OfferDetailViewController *offerDetailViewController;
@property (nonatomic, strong) CarPoolOffer *currentOffer;
@property (nonatomic, strong) NSMutableArray *offers;
@property (nonatomic, strong) SearchFilter *searchFilter;

- (IBAction)searchSelected:(id)sender;

@end
