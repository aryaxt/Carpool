//
//  CarPoolOfferClient.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CarPoolOfferClient.h"

@implementation CarPoolOfferClient

- (void)fetchCarpoolOffersForUser:(PFUser *)user includeLocations:(BOOL)includeLocations
                   withCompletion:(void (^)(NSArray *objects, NSError *error))completion;
{
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([CarPoolOffer class])];
    [query whereKey:@"user" equalTo:user];
    
    if (includeLocations)
    {
        [query includeKey:@"startLocation"];
        [query includeKey:@"endLocation"];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSMutableArray *offers = [NSMutableArray array];
        for (PFObject *object in objects)
        {
            [offers addObject:(CarPoolOffer *)object];
        }
        
        completion(offers, error);
    }];
}

- (void)deleteCarpoolOffer:(CarPoolOffer *)offer withCompletion:(void (^)(BOOL succeeded, NSError *error))completion
{
    [offer deleteInBackgroundWithBlock:completion];
}

- (void)createOffer:(CarPoolOffer *)offer withCompletion:(void (^)(BOOL succeeded, NSError *error))completion
{
    [offer saveInBackgroundWithBlock:completion];
}

@end
