//
//  LocationSearchClient.m
//  CarPool
//
//  Created by Aryan on 5/10/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "LocationSearchClient.h"
#import <SPGooglePlacesAutocomplete/SPGooglePlacesAutocomplete.h>
#import "Location.h"

@implementation LocationSearchClient

#define AUTOCOMPLETE_API_KEY @"AIzaSyC52xwGjuNVfBq4yHlQiGrlswCERkZZ16w"

- (void)searchByKeyword:(NSString *)keyWord withCompletion:(void (^)(NSArray *locations, NSError *error))completion
{
    SPGooglePlacesAutocompleteQuery *query = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:AUTOCOMPLETE_API_KEY];
    query.input = keyWord;
    query.language = @"en";
    query.types = SPPlaceTypeGeocode;
    
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            NSMutableArray *locations = [NSMutableArray array];
            
            for (SPGooglePlacesAutocompletePlace *place in places)
            {
                [locations addObject:[Location locationFromGoogleAutoCompletePLace:place]];
            }
            
            completion(locations, nil);
        }
    }];
}

- (void)searchByLocation:(CLLocation *)location withCompletion:(void (^)(NSArray *locations, NSError *error))completion
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error)
                       {
                           completion(nil, error);
                       }
                       else
                       {
                           NSMutableArray *locations = [NSMutableArray array];
                           
                           for (CLPlacemark *placeMark in placemarks)
                           {
                               [locations addObject:[Location locationFromPlaceMark:placeMark]];
                           }
                           
                           completion(locations, nil);
                       }
                   }];
}

@end
