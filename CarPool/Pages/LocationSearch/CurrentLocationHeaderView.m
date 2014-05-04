//
//  CurrentLocationHeaderView.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CurrentLocationHeaderView.h"

@implementation CurrentLocationHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CurrentLocationHeaderView" owner:nil options:nil] lastObject];
    return self;
}

- (IBAction)currentLocationSelected:(id)sender
{
    [self.delegate currentLocationHeaderViewDidDetectTap];
}

@end
