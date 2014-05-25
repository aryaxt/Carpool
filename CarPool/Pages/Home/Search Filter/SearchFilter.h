//
//  SearchFilter.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface SearchFilter : NSObject

@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *minAge;
@property (nonatomic, strong) NSNumber *maxAge;
@property (nonatomic, strong) Location *startLocation;
@property (nonatomic, strong) Location *endLocation;

@end
