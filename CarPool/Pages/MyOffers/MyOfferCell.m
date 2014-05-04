//
//  OfferCell.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MyOfferCell.h"

@implementation MyOfferCell

#pragma - Public Methods -

- (void)setOffer:(CarPoolOffer *)offer
{
    
}

#pragma - IBActions -

- (IBAction)deleteSelected:(id)sender
{
    [self.delegate myOfferCellDidSelectDelete:self];
}

@end
