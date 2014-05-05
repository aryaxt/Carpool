//
//  Location.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Parse/Parse.h>
#import <SPGooglePlacesAutocomplete/SPGooglePlacesAutocompletePlace.h>

@interface Location : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *reference;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) PFGeoPoint *geoPoint;

+ (Location *)locationFrom:(SPGooglePlacesAutocompletePlace *)autoCompletePlace;

@end
