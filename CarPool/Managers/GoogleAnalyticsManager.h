//
//  GooglaAnalyticsManager.h
//  CarPool
//
//  Created by Aryan on 5/31/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleAnalyticsManager : NSObject

extern NSString *GoogleAnalyticsManagerCategoryRequest;
extern NSString *GoogleAnalyticsManagerCategoryOffer;
extern NSString *GoogleAnalyticsManagerCategoryReference;
extern NSString *GoogleAnalyticsManagerActionCreate;

+ (GoogleAnalyticsManager *)sharedInstance;
- (void)trackPage:(NSString *)page;
- (void)trackEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label andValue:(NSNumber *)value;

@end
