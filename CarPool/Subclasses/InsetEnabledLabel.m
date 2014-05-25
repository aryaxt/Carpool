//
//  InsetEnabledLabel.m
//  CarPool
//
//  Created by Aryan on 5/25/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "InsetEnabledLabel.h"

@implementation InsetEnabledLabel

#pragma mark - Public Methods -

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    
    [self setNeedsDisplay];
}

#pragma mark - Draw -

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
