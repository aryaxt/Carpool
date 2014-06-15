//
//  BaseViewController.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleAnalyticsManager.h"

@interface BaseViewController : UIViewController

- (void)trackPage:(NSString *)page;
- (void)trackEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label andValue:(NSNumber *)value;
- (void)alertWithtitle:(NSString *)title andMessage:(NSString *)message;
- (void)showLoader;
- (void)hideLoader;

@end
