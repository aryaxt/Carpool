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
    PFQuery *query = [Reference query];
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
    __block NSError *error;
    __block NSInteger count = 0;
    __block NSNumber *positive;
    __block NSNumber *negative;
    
    void(^referenceCompletion)(NSError *) = ^(NSError *newError) {
        count++;
        
        if (!error)
            error = newError;
        
        if (count == 2)
            completion(positive, negative, error);
    };
    
    [self fetchReferenceCountForUser:user withReferenceType:ReferenceTypePositive andCompletion:^(NSNumber *count, NSError *error) {
        positive = count;
        referenceCompletion(error);
    }];
    
    [self fetchReferenceCountForUser:user withReferenceType:ReferenceTypeNegative andCompletion:^(NSNumber *count, NSError *error) {
        negative =  count;
        referenceCompletion(error);
    }];
}

- (void)fetchReferenceCountForUser:(User *)user withReferenceType:(NSString *)type andCompletion:(void (^)(NSNumber *count, NSError *error))completion
{
    PFQuery *query = [Reference query];
    [query whereKey:@"to" equalTo:user];
    
    if (type)
    {
        [query whereKey:@"type" equalTo:type];
    }
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
       if (error)
       {
           completion(nil, error);
       }
       else
       {
           completion(@(number), nil);
       }
    }];
}

- (void)fetchReferencesForUser:(User *)user
                        byType:(NSString *)type
                          limit:(NSInteger)limit
                       skip:(NSInteger)skip
                 andCompletion:(void (^)(NSArray *references, NSError *error))completion
{
    PFQuery *query = [Reference query];
    [query whereKey:@"to" equalTo:user];
    [query includeKey:@"from"];
    [query setLimit:limit];
    [query setSkip:skip];
    
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
