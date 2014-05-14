//
//  CarPoolRequestClient.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarPoolRequest.h"

@interface CarPoolRequestClient : NSObject

- (void)createRequest:(CarPoolRequest *)request withCompletion:(void (^)(BOOL succeeded, NSError *error))completion;

@end
