//
//  CarPoolRequestEngine.m
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CarPoolRequestEngine.h"

@implementation CarPoolRequestEngine

- (void)createRequest:(CarPoolRequest *)request withInitialComment:(Comment *)comment andCompletion:(void (^)(NSError *error))completion
{
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            completion(error);
        }
        else
        {
            comment.request = request;
            
            [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *saveError) {
                if (saveError)
                {
                    [request deleteEventually];
                    completion(saveError);
                }
                else
                {
                    [request.comments addObject:comment];
                    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error)
                        {
                            [comment deleteEventually];
                            [request deleteEventually];
                            completion(error);
                        }
                        else
                        {
                            completion(nil);
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)updateRequest:(CarPoolRequest *)request withStatus:(BOOL)status andCompletion:(void (^)(Comment *comment, NSError *error))completion
{
    if (request.status != nil)
    {
        completion(nil, [NSError errorWithDomain:@"Cannot change status of request" code:0 userInfo:nil]);
        return;
    }
    
    [request refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error)
        {
            completion(nil, error);
            return;
        }
        
        CarPoolRequest *refreshedRequest = (CarPoolRequest *)request;
        
        if (refreshedRequest.status != nil)
        {
            completion(nil, [NSError errorWithDomain:@"Cannot change status of request" code:0 userInfo:nil]);
            return;
        }
        
        refreshedRequest.status = (status) ? @YES : @NO;
        [refreshedRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
            {
                completion(nil, error);
                return;
            }
            
            Comment *comment = [[Comment alloc] init];
            comment.request = refreshedRequest;
            comment.from = request.to;
            comment.to = request.from;
            comment.message = (status) ? @"Accepted your request" : @"Declined your request";
            
            [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error)
                {
                    completion(nil, error);
                    [comment deleteEventually];
                }
                else
                {
                    completion(comment, nil);
                }
            }];
        }];
        
    }];
}

@end
