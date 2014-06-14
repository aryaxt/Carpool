//
//  GooglaAnalyticsManager.m
//  CarPool
//
//  Created by Aryan on 5/31/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "GoogleAnalyticsManager.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAI.h"

NSString *GoogleAnalyticsManagerCategoryRequest = @"Request";
NSString *GoogleAnalyticsManagerCategoryOffer = @"Offer";
NSString *GoogleAnalyticsManagerCategoryReference = @"Reference";
NSString *GoogleAnalyticsManagerActionCreate = @"Create";

@implementation GoogleAnalyticsManager

#pragma mark - Initialization -

+ (GoogleAnalyticsManager *)sharedInstance;
{
    static dispatch_once_t onceToken;
    static GoogleAnalyticsManager *singleton;
    
    dispatch_once(&onceToken, ^{
        singleton = [[GoogleAnalyticsManager alloc] init];
    });
    
    return singleton;
}

- (id)init
{
    if (self = [super init])
    {
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        [GAI sharedInstance].dispatchInterval = 20;
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelWarning];
        [[GAI sharedInstance] trackerWithTrackingId:@"UA-35738460-5"];
    }
    
    return self;
}

#pragma mark - Public Methods -

- (void)trackPage:(NSString *)page
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:page];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)trackEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label andValue:(NSNumber *)value
{
    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:value] build]];
}

@end
