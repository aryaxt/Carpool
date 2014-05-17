//
//  CarPoolRequestClient.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CarPoolRequestClient.h"

@implementation CarPoolRequestClient

- (void)fetchMyRequestsIncludeOffer:(BOOL)includeOffer
                        includeFrom:(BOOL)includeFrom
                          includeTo:(BOOL)includeTo
                     withCompletion:(void (^)(NSArray *requests, NSError *error))completion
{
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([CarPoolRequest class])];
    [query whereKey:@"to" equalTo:[User currentUser]];
    [query whereKey:@"time" greaterThanOrEqualTo:[NSDate date]];
    
    if (includeOffer)
        [query includeKey:@"offer"];
    
    if (includeFrom)
        [query includeKey:@"from"];
    
    if (includeTo)
        [query includeKey:@"to"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSMutableArray *requests = [NSMutableArray array];
        
        for (PFObject *object in objects)
        {
            [requests addObject:(CarPoolRequest *)object];
        }
        
        completion(requests, error);
    }];
}

- (void)fetchRequestById:(NSString *)objectId withCompletion:(void (^)(CarPoolRequest *request, NSError *error))completion
{
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([CarPoolRequest class])];
    [query includeKey:@"from"];
    [query includeKey:@"to"];
    [query includeKey:@"startLocation"];
    [query includeKey:@"endLocation"];
    [query includeKey:@"offer"];
    [query includeKey:@"offer.startLocation"];
    [query includeKey:@"offer.endLocation"];
    
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *object, NSError *error) {
        completion((CarPoolRequest *)object, error);
    }];
}

@end
