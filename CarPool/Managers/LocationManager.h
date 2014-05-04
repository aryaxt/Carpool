//
//  LocationManager.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

@property (nonatomic, strong, readonly) CLLocation *currentLocation;

+ (LocationManager *)sharedInstance;

@end
