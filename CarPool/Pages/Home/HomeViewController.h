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

@interface HomeViewController : BaseViewController <SlideNavigationControllerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UIToolbar *searchToolbar;

- (IBAction)searchSelected:(id)sender;

@end
