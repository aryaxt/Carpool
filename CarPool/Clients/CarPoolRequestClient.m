//
//  CarPoolRequestClient.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CarPoolRequestClient.h"
#import "NSDate+Additions.h"

@implementation CarPoolRequestClient

- (void)fetchMyRequestsIncludeOffer:(BOOL)includeOffer
                        includeFrom:(BOOL)includeFrom
                          includeTo:(BOOL)includeTo
                     withCompletion:(void (^)(NSArray *requests, NSError *error))completion
{
    PFQuery *query = [CarPoolRequest query];
    [query whereKey:@"from" equalTo:[User currentUser]];
    [query whereKey:@"date" greaterThanOrEqualTo:[NSDate dateWithoutTimeComponents]];
    [query includeKey:@"startLocation"];
    [query includeKey:@"endLocation"];
    
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
    PFQuery *query = [CarPoolRequest query];
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

- (void)updateRequestWithId:(NSString *)requestId withStatus:(NSString *)status withCompletion:(void (^)(Comment *comment, NSError *error))completion
{
    [PFCloud callFunctionInBackground:@"UpdateRequestStatus"
                       withParameters:@{@"requestId" : requestId, @"status" : status}
                                block:^(id object, NSError *error) {
                                    if (error)
                                    {
                                        completion(nil, error);
                                    }
                                    else
                                    {
                                        completion(object, nil);
                                    }
                                }];
}

- (void)saveRequest:(CarPoolRequest *)request withCompletion:(void (^)(NSError *error))completion
{
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(error);
    }];
}

@end
