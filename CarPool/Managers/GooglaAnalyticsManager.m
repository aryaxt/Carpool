//
//  GooglaAnalyticsManager.m
//  CarPool
//
//  Created by Aryan on 5/31/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "GooglaAnalyticsManager.h"

@implementation GooglaAnalyticsManager

#pragma mark - Initialization -

+ (GooglaAnalyticsManager *)sharedInstance;
{
    static dispatch_once_t onceToken;
    static GooglaAnalyticsManager *singleton;
    
    dispatch_once(&onceToken, ^{
        singleton = [[GooglaAnalyticsManager alloc] init];
    });
    
    return singleton;
}

@end
