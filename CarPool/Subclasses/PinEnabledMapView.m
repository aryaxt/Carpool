//
//  PinEnabledMapView.m
//  CarPool
//
//  Created by Aryan on 5/10/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "PinEnabledMapView.h"
#import "LocationSearchClient.h"
#import "LocationManager.h"

@interface PinEnabledMapView()<MKMapViewDelegate>
@property (nonatomic, strong) LocationSearchClient *searchclient;
@property (nonatomic, strong) UIView *loadingView;
@end

@implementation PinEnabledMapView

#pragma mark - Initialization -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.delegate = self;
    
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    [self addGestureRecognizer:gestureRecognizer];
    
    [self goToCurrentLocation];
}

#pragma mark - Private MEthods -

- (void)goToCurrentLocation
{
    MKCoordinateRegion region;
    region.center = [LocationManager sharedInstance].currentLocation.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 1;
    span.longitudeDelta = 1;
    region.span = span;
    
    [self setRegion:region animated:YES];
}

#pragma mark - UIGestureRecognizer -

- (void)longPressDetected:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
        
    CGPoint point = [gestureRecognizer locationInView:self];
    CLLocationCoordinate2D coord = [self convertPoint:point toCoordinateFromView:self];
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coord altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:0];
    _pinLocation = coord;
    
    __weak PinEnabledMapView *wekSelf = self;
    
    [self setShowLoading:YES withCompletion:nil];
    
    [self.searchclient searchByLocation:location withCompletion:^(NSArray *locations, NSError *error) {
        [wekSelf setShowLoading:NO withCompletion:^{
            if (!error && locations.count == 1)
            {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                [annotation setCoordinate:coord];
                [annotation setTitle:[[locations firstObject] name]];
                [wekSelf removeAnnotations:[wekSelf annotations]];
                [wekSelf addAnnotation:annotation];
                [wekSelf selectAnnotation:annotation animated:YES];
            }
        }];
    }];
}

- (void)setShowLoading:(BOOL)show withCompletion:(void (^)())completion
{
    if (show)
    {
        self.loadingView = [[UIView alloc] initWithFrame:self.bounds];
        self.loadingView.backgroundColor = [UIColor blackColor];
        self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.loadingView];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
        [activityIndicator startAnimating];
        activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [activityIndicator setCenter:self.loadingView.center];
        [self.loadingView addSubview:activityIndicator];
        
        self.loadingView.alpha = 0;
        
        [UIView animateWithDuration:.5 animations:^{
            self.loadingView.alpha = .5;
        } completion:^(BOOL finished) {
            if (completion)
                completion();
        }];
    }
    else
    {
        [UIView animateWithDuration:.5 animations:^{
            self.loadingView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.loadingView removeFromSuperview];
            self.loadingView = nil;
            
            if (completion)
                completion();
        }];
    }
}

#pragma mark - Setter & Getter -

- (LocationSearchClient *)searchclient
{
    if (!_searchclient)
    {
        _searchclient = [[LocationSearchClient alloc] init];
    }
    
    return _searchclient;
}

@end
