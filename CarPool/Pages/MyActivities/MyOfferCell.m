//
//  OfferCell.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MyOfferCell.h"

@implementation MyOfferCell

#pragma mark - Public Methods -

- (void)setOffer:(CarPoolOffer *)offer
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    self.lblTime.text = [dateFormatter stringFromDate:offer.time];
    self.lblFrom.text = offer.startLocation.name;
    self.lblTo.text = offer.endLocation.name;
}

@end
