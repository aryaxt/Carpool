//
//  HomeViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "HomeViewController.h"
#import <MapKit/MapKit.h>
#import "SlideNavigationController.h"
#import "CarPoolOfferClient.h"
#import "HomeOfferDetailViewController.h"
#import "UIColor+Additions.h"
#import "CarPoolOffer.h"
#import "CarPoolRequest.h"
#import "LocationManager.h"
#import "UIViewController+Additions.h"
#import "SearchFilterViewController.h"
#import "SearchFilter.h"
#import "CreateRequestStepsViewController.h"
#import "ProfileViewController.h"

@interface HomeViewController() <SlideNavigationControllerDelegate, MKMapViewDelegate, HomeOfferDetailViewControllerDelegate, SearchFilterViewControllerDelegate, CreateRequestStepsViewControllerDelegate>
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CarPoolOfferClient *offerClient;
@property (nonatomic, strong) HomeOfferDetailViewController *offerDetailViewController;
@property (nonatomic, strong) CarPoolOffer *currentOffer;
@property (nonatomic, strong) NSMutableArray *offers;
@property (nonatomic, strong) SearchFilter *searchFilter;
@end

@implementation HomeViewController

#define STATUS_BAR_HEIGHT 20
#define NAV_BAR_HEIGHT 44
#define DETAIL_VIEW_ANIMATION .25
#define DETAIL_VIEW_QUICK_ANIMATION .15

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self trackPage:GoogleAnalyticsManagerPageHome];
    
    self.searchFilter = [[SearchFilter alloc] init];
    self.mapView.delegate = self;
    
    [self performSearch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.view addSubview:self.offerDetailViewController.view];
    [self setHideOfferDetail:(self.offers.count) ? NO : YES animated:NO withCompletion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.offerDetailViewController.view removeFromSuperview];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchFilterViewController"])
    {
        SearchFilterViewController *vc = segue.destinationViewController;
        vc.searchFilter = self.searchFilter;
        vc.delegate = self;
    }
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - IBActions -

- (IBAction)searchSelected:(id)sender
{
    
}

- (IBAction)filterButtonSelected:(id)sender
{
    [[SlideNavigationController sharedInstance] toggleRightMenu];
}

#pragma mark - UITableView Delegate & Datasource -

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

#pragma mark - SearchFilterViewControllerDelegate -

- (void)searchFilterViewControllerDidApplyFilter:(SearchFilter *)filter
{
    //TODO: hide detail at the bottom of screen until search is performed
    [self.navigationController popViewControllerAnimated:YES];
    self.searchFilter = filter;
    [self performSearch];
}

#pragma mark - MKMapViewDelegate -

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{

}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor randomColor]];
        [renderer setLineWidth:2.0];
        
        [self.mapView setRegion:MKCoordinateRegionForMapRect([overlay boundingMapRect])
                       animated:YES];
        
        return renderer;
    }
    
    return nil;
}

#pragma mark - OfferDetailViewControllerDelegate -

- (void)homeOfferDetailViewControllerDidSelectNext
{
    NSInteger index = [self.offers indexOfObject:self.currentOffer];
    [self setCurrentOffer:[self.offers objectAtIndex:index+1]];
}

- (void)homeOfferDetailViewControllerDidSelectPrevious
{
    NSInteger index = [self.offers indexOfObject:self.currentOffer];
    [self setCurrentOffer:[self.offers objectAtIndex:index-1]];
}

- (void)homeOfferDetailViewControllerDidSelectExpand
{
    CGRect rect = self.offerDetailViewController.view.frame;
    [self setExpandOfferDetail:(rect.origin.y > self.view.frame.size.height/2) ? YES : NO
                withDuration:DETAIL_VIEW_ANIMATION];
}

- (void)homeOfferDetailViewControllerDidDetectPan:(UIPanGestureRecognizer *)pan
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
            [self setExpandOfferDetail:(velocityY > 0) ? NO : YES
                        withDuration:DETAIL_VIEW_QUICK_ANIMATION];
        }
        else
        {
            [self setExpandOfferDetail:(rect.origin.y > self.view.frame.size.height/2) ? NO : YES
                        withDuration:DETAIL_VIEW_ANIMATION];
        }
    }
}

- (void)homeOfferDetailViewControllerDidSelectRequestForOffer:(CarPoolOffer *)offer
{
    __weak HomeViewController *selfReference = self;
    
    [self setHideOfferDetail:YES animated:YES withCompletion:^{
        CreateRequestStepsViewController *vc = [CreateRequestStepsViewController viewController];
        vc.delegate = selfReference;
        vc.offer = offer;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        [selfReference presentViewController:navController animated:YES completion:nil];
    }];
}

- (void)homeOfferDetailViewControllerDidSelectViewUserProfile:(User *)user
{
    __weak HomeViewController *selfReference = self;
    
    [self setHideOfferDetail:YES animated:YES withCompletion:^{
        ProfileViewController *vc = [ProfileViewController viewController];
        vc.user = user;
        vc.shouldEnableSlideMenu = NO;
        [selfReference.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - Private MEthods -

- (void)setExpandOfferDetail:(BOOL)expand withDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect rect = _offerDetailViewController.view.frame;
                         rect.origin.y = (expand) ? STATUS_BAR_HEIGHT : self.navigationController.view.frame.size.height-NAV_BAR_HEIGHT;
                         _offerDetailViewController.view.frame = rect;
                     } completion:nil];
}

- (void)setHideOfferDetail:(BOOL)hide animated:(BOOL)animated withCompletion:(void (^)())completion
{
    [UIView animateWithDuration:(animated) ? .3 : 0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect rect = _offerDetailViewController.view.frame;
                         rect.origin.y = (hide) ? self.navigationController.view.frame.size.height : self.navigationController.view.frame.size.height-NAV_BAR_HEIGHT;
                         _offerDetailViewController.view.frame = rect;
                     } completion:^(BOOL finished) {
                         if (completion)
                             completion();
                     }];
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

- (void)addPolylineFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to
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

- (void)performSearch
{
    [self.offerClient searchLocation:CLLocationCoordinate2DMake(0, 0)
                                 withLimit:10
                             andCompletion:^(NSArray *offers, NSError *error) {
                                 
                                 [self setHideOfferDetail:(offers.count) ? NO : YES animated:YES withCompletion:nil];
                                 
                                 if (error)
                                 {
                                     [self alertWithtitle:@"Error"
                                               andMessage:@"There was a problem searching for carpool offers"];
                                 }
                                 else
                                 {
                                     self.title = [NSString stringWithFormat:@"Found %lu Offers", (unsigned long)offers.count];
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

#pragma mark - CreateRequestStepsViewControllerDelegate -

- (void)createRequestStepsViewControllerDidSelectCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createRequestStepsViewControllerDidCreateRequest:(CarPoolRequest *)request
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setter & Getter -

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
    
    [self addPolylineFrom:from to:to];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    [self addPinsFrom:from to:to];
}

- (CarPoolOfferClient *)offerClient
{
    if (!_offerClient)
    {
        _offerClient = [[CarPoolOfferClient alloc] init];
    }
    
    return _offerClient;
}

- (HomeOfferDetailViewController *)offerDetailViewController
{
    if (!_offerDetailViewController)
    {
        _offerDetailViewController = (HomeOfferDetailViewController *)[HomeOfferDetailViewController viewController];
        _offerDetailViewController.delegate = self;
    }
    
    return _offerDetailViewController;
}

@end
