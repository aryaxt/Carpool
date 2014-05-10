//
//  CurrentLocationHeaderView.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "LocationSearchHeaderView.h"

@implementation LocationSearchHeaderView

#pragma - Initialization -

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"LocationSearchHeaderView" owner:nil options:nil] lastObject];
    return self;
}

#pragma - IBActions -

- (IBAction)currentLocationSelected:(id)sender
{
    [self.delegate locationSearchHeaderViewDidSelectCurrentLocationSearch];
}

- (IBAction)mapSelected:(id)sender
{
    [self.delegate locationSearchHeaderViewDidSelectMapSearch];
}

@end
