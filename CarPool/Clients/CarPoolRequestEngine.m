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

@end
