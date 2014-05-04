//
//  UIViewController+Additions.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

+ (UIViewController *)viewControllerByIdentifier:(NSString *)identifier;
+ (UIViewController *)viewController;

@end
