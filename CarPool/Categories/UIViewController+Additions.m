//
//  UIViewController+Additions.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

+ (id)viewControllerByIdentifier:(NSString *)identifier
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:identifier];
}

+ (id)viewController
{
    return [[self class] viewControllerByIdentifier:NSStringFromClass(self)];
}

@end
