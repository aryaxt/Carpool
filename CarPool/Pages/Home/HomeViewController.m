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
#import "UIViewController+Additions.h"

@implementation HomeViewController

#define STATUS_BAR_HEIGHT 20
#define NAV_BAR_HEIGHT 44
#define DETAIL_VIEW_ANIMATION .3
#define DETAIL_VIEW_QUICK_ANIMATION .15

#pragma - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [self.offerClient fetchCarpoolOffersForUser:[PFUser currentUser]
                               includeLocations:YES
                                    includeUser:YES
                                 withCompletion:^(NSArray *offers, NSError *error) {
                                     if (error)
                                     {
                                         [self alertWithtitle:@"Error"
                                                   andMessage:@"There was a problem searching for carpool offers"];
                                     }
                                     else
                                     {
                                         self.offers = [offers mutableCopy];
                                         
                                         if (offers.count)
                                         {
                                             [self setCurrentOffer:[self.offers firstObject]];
                                         }
                                         else
                                         {
                                            // ANIMATE toolbar down
                                         }
                                     }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.view addSubview:self.offerDetailViewController.view];
    [self setShowOfferDetail:NO withDuration:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.offerDetailViewController.view removeFromSuperview];
}

#pragma - Private Methods -

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region;
    region.center = mapView.userLocation.coordinate;
    region.span = MKCoordinateSpanMake(1, 1);
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

#pragma - IBActions -

- (IBAction)searchSelected:(id)sender
{
    
}

#pragma - UITableView Delegate & Datasource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma - Private MEthods -

- (void)addPolulineFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:from
                                                                                     addressDictionary:nil]];
    
    MKMapItem *toItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to
                                                                                   addressDictionary:nil]];
    
    [request setSource:fromItem];
    [request setDestination:toItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    [request setRequestsAlternateRoutes:YES];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [self showLoader];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        [self hideLoader];
        
        if (!error)
        {
            for (MKRoute *route in [response routes])
            {
                [self.mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
            }
        }
    }];
}

- (UIColor *)randomColor
{
    CGFloat redLevel = rand() / (float) RAND_MAX;
    CGFloat greenLevel = rand() / (float) RAND_MAX;
    CGFloat blueLevel = rand() / (float) RAND_MAX;
    
    return [UIColor colorWithRed:redLevel
                           green:greenLevel
                            blue:blueLevel
                           alpha:1.0];
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[self randomColor]];
        [renderer setLineWidth:5.0];
        
        [self.mapView setRegion:MKCoordinateRegionForMapRect([overlay boundingMapRect])
                       animated:YES];
        
        return renderer;
    }
    
    return nil;
}

#pragma - OfferDetailViewControllerDelegate -

- (void)offerDetailViewControllerDidSelectNext
{
    NSInteger index = [self.offers indexOfObject:self.currentOffer];
    [self setCurrentOffer:[self.offers objectAtIndex:index+1]];
}

- (void)offerDetailViewControllerDidSelectPrevious
{
    NSInteger index = [self.offers indexOfObject:self.currentOffer];
    [self setCurrentOffer:[self.offers objectAtIndex:index-1]];
}

- (void)offerDetailViewControllerDidSelectExpand
{
    CGRect rect = self.offerDetailViewController.view.frame;
    [self setShowOfferDetail:(rect.origin.y > self.view.frame.size.height/2) ? YES : NO
                withDuration:DETAIL_VIEW_ANIMATION];
}

- (void)setShowOfferDetail:(BOOL)show withDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        CGRect rect = _offerDetailViewController.view.frame;
        rect.origin.y = (show) ? STATUS_BAR_HEIGHT : self.navigationController.view.frame.size.height-NAV_BAR_HEIGHT;
        _offerDetailViewController.view.frame = rect;
    } completion:nil];
}

- (void)offerDetailViewControllerDidDetectPan:(UIPanGestureRecognizer *)pan
{
    static CGPoint previousPoint;
    
    CGPoint translation = [pan translationInView:pan.view];
    CGPoint velocityPoint = [pan velocityInView:pan.view];
    NSInteger velocityY = velocityPoint.y;
    NSInteger positiveYVelocity = (velocityY < 0) ? velocityY*-1 : velocityY;
	NSInteger movementY = translation.y - previousPoint.y;
    previousPoint = translation;
    
    CGRect rect = _offerDetailViewController.view.frame;
    rect.origin.y = rect.origin.y + movementY;
    if(rect.origin.y > STATUS_BAR_HEIGHT && rect.origin.y < self.navigationController.view.frame.size.height - NAV_BAR_HEIGHT)
    _offerDetailViewController.view.frame = rect;
    
    
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        previousPoint = CGPointZero;
        
        if (positiveYVelocity > 500)
        {
            [self setShowOfferDetail:(velocityY > 0) ? NO : YES
                        withDuration:DETAIL_VIEW_QUICK_ANIMATION];
        }
        else
        {
            [self setShowOfferDetail:(rect.origin.y > self.view.frame.size.height/2) ? NO : YES
                        withDuration:DETAIL_VIEW_ANIMATION];
        }
    }
}

#pragma - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma - Setter & Getter -

- (void)setCurrentOffer:(CarPoolOffer *)currentOffer
{
    _currentOffer = currentOffer;
    
    [self.offerDetailViewController setCarPoolOffer:currentOffer];
    
    CLLocationCoordinate2D from = CLLocationCoordinate2DMake(
                                                             currentOffer.startLocation.geoPoint.latitude,
                                                             currentOffer.startLocation.geoPoint.longitude);
    
    CLLocationCoordinate2D to = CLLocationCoordinate2DMake(
                                                           currentOffer.endLocation.geoPoint.latitude,
                                                           currentOffer.endLocation.geoPoint.longitude);
    
    [self addPolulineFrom:from to:to];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    [self addPinsFrom:from to:to];
}

- (void)addPinsFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to
{
    MKPointAnnotation *annotationFrom = [[MKPointAnnotation alloc] init];
    [annotationFrom setCoordinate:from];
    [annotationFrom setTitle:@"From"];
    [self.mapView addAnnotation:annotationFrom];
    
    MKPointAnnotation *annotationTo = [[MKPointAnnotation alloc] init];
    [annotationTo setCoordinate:to];
    [annotationTo setTitle:@"To"];
    [self.mapView addAnnotation:annotationTo];
}

- (CarPoolOfferClient *)offerClient
{
    if (!_offerClient)
    {
        _offerClient = [[CarPoolOfferClient alloc] init];
    }
    
    return _offerClient;
}

- (OfferDetailViewController *)offerDetailViewController
{
    if (!_offerDetailViewController)
    {
        _offerDetailViewController = (OfferDetailViewController *)[OfferDetailViewController viewController];
        _offerDetailViewController.delegate = self;
        _offerDetailViewController.view.alpha = .9;
    }
    
    return _offerDetailViewController;
}

@end
