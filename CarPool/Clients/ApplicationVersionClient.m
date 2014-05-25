//
//  ApplicationVersionClient.m
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ApplicationVersionClient.h"

@implementation ApplicationVersionClient

- (void)fetchLatestByPlatform:(NSString *)platform andCompletion:(void (^)(ApplicationVersion *applicationVersion, NSError *error))completion
{
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([ApplicationVersion class])];
    [query whereKey:@"platform" equalTo:platform];
    [query orderByDescending:@"createdAt"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            completion((ApplicationVersion *)object, nil);
        }
    }];
}

@end
