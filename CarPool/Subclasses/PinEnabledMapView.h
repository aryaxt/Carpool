//
//  PinEnabledMapView.h
//  CarPool
//
//  Created by Aryan on 5/10/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Location.h"

@protocol PinEnabledMapViewDelegate <MKMapViewDelegate>
- (void)pinEnabledMapViewWillStartSearchingInCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)pinEnabledMapViewDidFailToSearchWithError:(NSError *)error;
- (void)pinEnabledMapViewDidFindLocations:(NSArray *)locations;
@end

@interface PinEnabledMapView : MKMapView

@property (nonatomic, weak) id <PinEnabledMapViewDelegate> delegate;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D pinLocation;

- (Location *)locationAtIndex:(NSInteger)index;

@end
