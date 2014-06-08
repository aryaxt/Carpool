//
//  CarPoolOfferClient.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CarPoolOfferClient.h"

@implementation CarPoolOfferClient

- (void)fetchMyOffersIncludeLocations:(BOOL)includeLocations includeUser:(BOOL)includeUser withCompletion:(void (^)(NSArray *objects, NSError *error))completion
{
    PFQuery *query = [CarPoolOffer query];
    [query whereKey:@"from" equalTo:[User currentUser]];
    [query whereKey:@"isActive" equalTo:@YES];
    
    if (includeLocations)
    {
        [query includeKey:@"startLocation"];
        [query includeKey:@"endLocation"];
    }
    
    if (includeUser)
    {
        [query includeKey:@"from"];
    }
    
    [self fetchOffersWithquery:query andCompletion:completion];
}

- (void)searchWithinGeoBoxWithSouthWestCoordinate:(CLLocationCoordinate2D)southWest andNorthEast:(CLLocationCoordinate2D)northEast withCompletion:(void (^)(NSArray *offers, NSError *error))completion
{
    PFGeoPoint *southWestGeoPiint = [PFGeoPoint geoPointWithLatitude:southWest.latitude longitude:southWest.longitude];
    PFGeoPoint *northeastGeoPiint = [PFGeoPoint geoPointWithLatitude:northEast.latitude longitude:northEast.longitude];
    
    PFQuery *query = [CarPoolOffer query];
    [query whereKey:@"startLocation" withinGeoBoxFromSouthwest:southWestGeoPiint toNortheast:northeastGeoPiint];
    [query whereKey:@"endLocation" withinGeoBoxFromSouthwest:southWestGeoPiint toNortheast:northeastGeoPiint];
    [query includeKey:@"startLocation"];
    [query includeKey:@"endLocation"];
    [query includeKey:@"from"];
    
    [self fetchOffersWithquery:query andCompletion:completion];
}

- (void)searchLocation:(CLLocationCoordinate2D)location withLimit:(NSInteger)limit andCompletion:(void (^)(NSArray *offers, NSError *error))completion
{
    //PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:location.latitude longitude:location.longitude];
    
    PFQuery *query = [CarPoolOffer query];
    //[query whereKey:@"startLocation" nearGeoPoint:geoPoint];
    //[query whereKey:@"endLocation" nearGeoPoint:geoPoint];
    [query setLimit:limit];
    [query includeKey:@"startLocation"];
    [query includeKey:@"endLocation"];
    [query includeKey:@"from"];
    
    [self fetchOffersWithquery:query andCompletion:completion];
}

- (void)deleteCarpoolOffer:(CarPoolOffer *)offer withCompletion:(void (^)(BOOL succeeded, NSError *error))completion
{
    [offer deleteInBackgroundWithBlock:completion];
}

- (void)createOffer:(CarPoolOffer *)offer withCompletion:(void (^)(BOOL succeeded, NSError *error))completion
{
    [offer saveInBackgroundWithBlock:completion];
}

#pragma mark - Private Methods -

- (void)fetchOffersWithquery:(PFQuery *)query andCompletion:(void (^)(NSArray *offers, NSError *error))completion
{
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSMutableArray *offers = [NSMutableArray array];
        for (PFObject *object in objects)
        {
            [offers addObject:(CarPoolOffer *)object];
        }
        
        completion(offers, error);
    }];
}

@end
