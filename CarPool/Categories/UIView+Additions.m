//
//  UIView+Additions.m
//  CarPool
//
//  Created by Aryan on 5/7/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (void)animatePopWithCompletion:(void (^)())completion
{
    self.transform = CGAffineTransformMakeScale(.1, .1);
    
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 12, 12);
                     }completion:^(BOOL finished) {
                         [UIView animateWithDuration:.1
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.transform = CGAffineTransformIdentity;
                                          }
                                          completion:^(BOOL finished) {
                                              if (completion)
                                                  completion();
                                          }];
                     }];
}

- (void)animateShrinkWithCompletion:(void (^)())completion
{
    [UIView animateWithDuration:.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 1.2, 1.2);
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.transform = CGAffineTransformScale(self.transform, .1, .1);
                                          } completion:^(BOOL finished) {
                                              if (completion)
                                                  completion();
                                          }];
                     }];
}

@end
