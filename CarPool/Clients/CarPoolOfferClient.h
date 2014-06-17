//
//  CarPoolOfferClient.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CarPoolOffer.h"

@interface CarPoolOfferClient : NSObject

- (void)deleteCarpoolOffer:(CarPoolOffer *)offer withCompletion:(void (^)(BOOL succeeded, NSError *error))completion;
- (void)createOffer:(CarPoolOffer *)offer withCompletion:(void (^)(BOOL succeeded, NSError *error))completion;
- (void)fetchMyOffersIncludeLocations:(BOOL)includeLocations includeUser:(BOOL)includeUser withCompletion:(void (^)(NSArray *objects, NSError *error))completion;
- (void)searchWithinGeoBoxWithSouthWestCoordinate:(CLLocationCoordinate2D)southWest andNorthEast:(CLLocationCoordinate2D)northEast withCompletion:(void (^)(NSArray *offers, NSError *error))completion;
- (void)searchLocation:(CLLocationCoordinate2D)location withLimit:(NSInteger)limit andCompletion:(void (^)(NSArray *offers, NSError *error))completion;
- (void)deactivateOffer:(CarPoolOffer *)offer withCompletion:(void (^)(NSError *))completion;

@end
