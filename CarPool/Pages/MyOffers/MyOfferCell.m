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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    self.lblTime.text = [dateFormatter stringFromDate:offer.time];
    self.lblFrom.text = offer.startLocation.name;
    self.lblTo.text = offer.endLocation.name;
}

#pragma - IBActions -

- (IBAction)deleteSelected:(id)sender
{
    [self.delegate myOfferCellDidSelectDelete:self];
}

- (IBAction)editSelected:(id)sender
{
    [self.delegate myOfferCellDidSelectEdit:self];
}

@end
