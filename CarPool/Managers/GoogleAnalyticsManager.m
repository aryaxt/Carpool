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

NSString *const GoogleAnalyticsManagerPageLogin = @"Login";
NSString *const GoogleAnalyticsManagerPageSignup = @"Signup";
NSString *const GoogleAnalyticsManagerPageHome = @"Home";
NSString *const GoogleAnalyticsManagerPageHomeSearchFilter = @"Home Search Filter";
NSString *const GoogleAnalyticsManagerPageInbox = @"Inbox";
NSString *const GoogleAnalyticsManagerPageMyActivities = @"My Activities";
NSString *const GoogleAnalyticsManagerPageRequestDetail = @"Request Detail";
NSString *const GoogleAnalyticsManagerPagePersonalMessage = @"Personal Message";
NSString *const GoogleAnalyticsManagerPageProfile = @"Profile";
NSString *const GoogleAnalyticsManagerPageReferences = @"References";
NSString *const GoogleAnalyticsManagerPageCreateReference = @"Create Reference";
NSString *const GoogleAnalyticsManagerPageCreateRequest = @"Create Request";
NSString *const GoogleAnalyticsManagerPageCreateOffer = @"Create Offer";
NSString *const GoogleAnalyticsManagerPageSettings = @"Settings";
NSString *const GoogleAnalyticsManagerPageNotificationSettings = @"Notification Settings";
NSString *const GoogleAnalyticsManagerCategoryRequest = @"Request";
NSString *const GoogleAnalyticsManagerCategoryOffer = @"Offer";
NSString *const GoogleAnalyticsManagerCategoryReference = @"Reference";
NSString *const GoogleAnalyticsManagerActionCreate = @"Create";

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
