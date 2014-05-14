//
//  LocationSearchClient.h
//  CarPool
//
//  Created by Aryan on 5/10/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationSearchClient : NSObject

- (void)searchByKeyword:(NSString *)keyWord withCompletion:(void (^)(NSArray *locations, NSError *error))completion;
- (void)searchByLocation:(CLLocation *)location withCompletion:(void (^)(NSArray *locations, NSError *error))completion;

@end
