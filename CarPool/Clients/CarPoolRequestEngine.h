//
//  CarPoolRequestEngine.h
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarPoolRequest.h"
#import "Comment.h"

@interface CarPoolRequestEngine : NSObject

- (void)createRequest:(CarPoolRequest *)request withInitialComment:(Comment *)comment andCompletion:(void (^)(NSError *error))completion;
- (void)updateRequest:(CarPoolRequest *)request withStatus:(BOOL)status andCompletion:(void (^)(NSError *error))completion;

@end
