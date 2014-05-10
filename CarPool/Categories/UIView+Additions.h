//
//  UIView+Additions.h
//  CarPool
//
//  Created by Aryan on 5/7/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (void)animatePopWithCompletion:(void (^)())completion;
- (void)animateShrinkWithCompletion:(void (^)())completion;

@end
