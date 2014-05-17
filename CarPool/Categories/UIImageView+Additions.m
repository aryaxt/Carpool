//
//  UIImageView+Additions.m
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIImageView (Additions)

- (void)setUserPhotoStyle
{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 2;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width/2;
}

@end
