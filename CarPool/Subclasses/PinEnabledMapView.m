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
@property (nonatomic, strong) NSArray *locations;
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
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    [self addGestureRecognizer:gestureRecognizer];
    
    [self goToCurrentLocation];
}

#pragma mark - Public MEthods -

- (Location *)locationAtIndex:(NSInteger)index
{
    return [self.locations objectAtIndex:index];
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
    
    [self.delegate pinEnabledMapViewWillStartSearchingInCoordinate:coord];
    
    CLLocation *clLocation = [[CLLocation alloc] initWithCoordinate:coord
                                                         altitude:0
                                               horizontalAccuracy:0
                                                 verticalAccuracy:0
                                                           course:0
                                                            speed:0
                                                        timestamp:0];
    _pinLocation = coord;
    
    __weak PinEnabledMapView *wekSelf = self;
    
    [self.searchclient searchByLocation:clLocation withCompletion:^(NSArray *locations, NSError *error) {
        
        wekSelf.locations = locations;
        [wekSelf removeAnnotations:[wekSelf annotations]];
        
        if (!error)
        {
            [self.delegate pinEnabledMapViewDidFindLocations:locations];
            
            for (Location *location in locations)
            {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                [annotation setCoordinate:coord];
                [annotation setTitle:location.name];
                [wekSelf addAnnotation:annotation];
            }
            
            if (locations.count == 1)
            {
                [wekSelf selectAnnotation:[self.annotations objectAtIndex:0] animated:YES];
                [self.delegate mapView:self didSelectAnnotationView:[self.annotations objectAtIndex:0]];;
            }
        }
        else
        {
            [self.delegate pinEnabledMapViewDidFailToSearchWithError:error];
        }
    }];
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
