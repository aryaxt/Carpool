//
//  CurrentLocationHeaderView.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "LocationSearchHeaderView.h"

@implementation LocationSearchHeaderView

#pragma mark - Initialization -

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"LocationSearchHeaderView" owner:nil options:nil] lastObject];
    self.layer.borderWidth = .6;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    return self;
}

#pragma mark - Public Methods -

- (void)setShowLoader:(BOOL)show
{
    if (show)
        [self.indicatorView startAnimating];
    else
        [self.indicatorView stopAnimating];
}

#pragma mark - IBActions -

- (IBAction)currentLocationSelected:(id)sender
{
    [self.delegate locationSearchHeaderViewDidSelectCurrentLocationSearch];
}

@end
