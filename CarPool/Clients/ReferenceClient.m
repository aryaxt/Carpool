//
//  ReferenceClient.m
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ReferenceClient.h"

@implementation ReferenceClient

- (void)fetchReferenceFromUser:(User *)from toUser:(User *)to withCompletion:(void (^)(Reference *, NSError *error))completion
{
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Reference class])];
    [query whereKey:@"from" equalTo:from];
    [query whereKey:@"to" equalTo:to];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            completion([objects firstObject], nil);
        }
    }];
}

- (void)saveReference:(Reference *)reference withCompletion:(void (^)(NSError *error))completion
{
    [reference saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(error);
    }];
}

- (void)fetchReferenceCountsForUser:(User *)user withCompletion:(void (^) (NSNumber *poitive, NSNumber *negative, NSError *error))completion
{
    [PFCloud callFunctionInBackground:@"ReferenceCount"
                       withParameters:@{@"id" : user.objectId}
                                block:^(NSDictionary *object, NSError *error) {
                                    if (error)
                                    {
                                        completion(nil, nil, error);
                                    }
                                    else
                                    {
                                        NSNumber *positive = @([[object objectForKey:@"positive"] intValue]);
                                        NSNumber *negative = @([[object objectForKey:@"negative"] intValue]);
                                        completion(positive, negative, nil);
                                    }
    }];
}

- (void)fetchReferencesForUser:(User *)user byType:(NSString *)type andCompletion:(void (^)(NSArray *references, NSError *error))completion
{
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Reference class])];
    [query whereKey:@"to" equalTo:user];
    
    if (type)
    {
        [query whereKey:@"type" equalTo:type];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            NSMutableArray *references = [NSMutableArray array];
            
            for (PFObject *object in objects)
            {
                [references addObject:(Reference *)object];
            }
            
            completion(references, nil);
        }
    }];
}

@end
