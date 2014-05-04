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

- (void)fetchCarpoolOffersForUSer:(PFUser *)user withCompletion:(void (^)(NSArray *objects, NSError *error))completion;
- (void)deleteCarpoolOffer:(CarPoolOffer *)offer withCompletion:(void (^)(BOOL succeeded, NSError *error))completion;

@end
