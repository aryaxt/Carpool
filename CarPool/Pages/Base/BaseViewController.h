//
//  BaseViewController.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)alertWithtitle:(NSString *)title andMessage:(NSString *)message;
- (void)showLoader;
- (void)hideLoader;

@end
