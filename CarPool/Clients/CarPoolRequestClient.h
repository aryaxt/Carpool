//
//  CarPoolRequestClient.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarPoolRequest.h"
#import "Comment.h"

@interface CarPoolRequestClient : NSObject

- (void)fetchRequestById:(NSString *)objectId withCompletion:(void (^)(CarPoolRequest *request, NSError *error))completion;
- (void)fetchMyRequestsIncludeOffer:(BOOL)includeOffer
                        includeFrom:(BOOL)includeFrom
                          includeTo:(BOOL)includeTo
                     withCompletion:(void (^)(NSArray *requests, NSError *error))completion;

@end
