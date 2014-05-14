//
//  CarPoolRequestClient.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CarPoolRequestClient.h"

@implementation CarPoolRequestClient

- (void)createRequest:(CarPoolRequest *)request withCompletion:(void (^)(BOOL succeeded, NSError *error))completion
{
    [request saveInBackgroundWithBlock:completion];
}

@end
