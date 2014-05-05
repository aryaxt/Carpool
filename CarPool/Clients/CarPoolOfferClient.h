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
- (void)fetchCarpoolOffersForUser:(PFUser *)user includeLocations:(BOOL)includeLocations withCompletion:(void (^)(NSArray *objects, NSError *error))completion;

@end
