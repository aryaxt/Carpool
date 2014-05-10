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

@interface HomeViewController : BaseViewController <SlideNavigationControllerDelegate, MKMapViewDelegate, OfferDetailViewControllerDelegate>

@property (nonatomic, strong) CarPoolOfferClient *offerClient;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) OfferDetailViewController *offerDetailViewController;
@property (nonatomic, strong) CarPoolOffer *currentOffer;
@property (nonatomic, strong) NSMutableArray *offers;

- (IBAction)searchSelected:(id)sender;

@end
