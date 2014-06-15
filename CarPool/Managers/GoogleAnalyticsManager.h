//
//  GooglaAnalyticsManager.h
//  CarPool
//
//  Created by Aryan on 5/31/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleAnalyticsManager : NSObject

extern NSString *const GoogleAnalyticsManagerPageLogin;
extern NSString *const GoogleAnalyticsManagerPageSignup;
extern NSString *const GoogleAnalyticsManagerPageHome;
extern NSString *const GoogleAnalyticsManagerPageHomeSearchFilter;
extern NSString *const GoogleAnalyticsManagerPageInbox;
extern NSString *const GoogleAnalyticsManagerPageMyActivities;
extern NSString *const GoogleAnalyticsManagerPageRequestDetail;
extern NSString *const GoogleAnalyticsManagerPagePersonalMessage;
extern NSString *const GoogleAnalyticsManagerPageProfile;
extern NSString *const GoogleAnalyticsManagerPageReferences;
extern NSString *const GoogleAnalyticsManagerPageCreateReference;
extern NSString *const GoogleAnalyticsManagerPageCreateRequest;
extern NSString *const GoogleAnalyticsManagerPageCreateOffer;
extern NSString *const GoogleAnalyticsManagerPageSettings;
extern NSString *const GoogleAnalyticsManagerPageNotificationSettings;
extern NSString *const constGoogleAnalyticsManagerCategoryRequest;
extern NSString *const constGoogleAnalyticsManagerCategoryOffer;
extern NSString *const constGoogleAnalyticsManagerCategoryReference;
extern NSString *const constGoogleAnalyticsManagerActionCreate;

+ (GoogleAnalyticsManager *)sharedInstance;
- (void)trackPage:(NSString *)page;
- (void)trackEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label andValue:(NSNumber *)value;

@end
