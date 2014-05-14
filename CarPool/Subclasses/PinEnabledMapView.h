//
//  PinEnabledMapView.h
//  CarPool
//
//  Created by Aryan on 5/10/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PinEnabledMapView : MKMapView

@property (nonatomic, assign, readonly) CLLocationCoordinate2D pinLocation;

@end
