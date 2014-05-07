//
//  HomeViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "HomeViewController.h"
#import "CarPoolOffer.h"
#import "LocationManager.h"

@implementation HomeViewController

#pragma - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [self.searchBar removeFromSuperview];
}

#pragma - Private Methods -

#pragma - IBActions -

- (IBAction)searchSelected:(id)sender
{
    
}

#pragma - MKMapViewDelegate -

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
   /* MKCoordinateRegion region;
    region.center.latitude = mapView.userLocation.coordinate.latitude;
    region.center.longitude = mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = .2;
    region.span.longitudeDelta = .2;
    
    [self.mapView setRegion:region animated:YES];*/
}

#pragma - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
