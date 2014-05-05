//
//  Location.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "Location.h"
#import <Parse/PFObject+Subclass.h>
#import <Parse/PFGeoPoint.h>

@implementation Location
@dynamic name;
@dynamic reference;
@dynamic identifier;
@dynamic geoPoint;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

+ (void)load
{
    [self registerSubclass];
}

+ (Location *)locationFrom:(SPGooglePlacesAutocompletePlace *)autoCompletePlace
{
    Location *location = [[Location alloc] init];
    location.name = autoCompletePlace.name;
    location.reference = autoCompletePlace.reference;
    location.identifier = autoCompletePlace.identifier;
    
    [autoCompletePlace resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
        location.geoPoint = [PFGeoPoint geoPointWithLatitude:placemark.location.coordinate.latitude
                                                   longitude:placemark.location.coordinate.longitude];
    }];
    
    return location;
}

@end