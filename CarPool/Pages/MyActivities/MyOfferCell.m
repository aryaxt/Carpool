//
//  OfferCell.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MyOfferCell.h"

@interface MyOfferCell()
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UILabel *lblFrom;
@property (nonatomic, strong) IBOutlet UILabel *lblTo;
@end

@implementation MyOfferCell

#pragma mark - Public Methods -

- (void)setOffer:(CarPoolOffer *)offer
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:([offer.period isEqual:CarPoolOfferPeriodOneTime])
        ? @"yyyy-MM-dd hh:mm a"
        : @"hh:mm a"];
    
    self.lblTime.text = [dateFormatter stringFromDate:offer.date];
    self.lblFrom.text = offer.startLocation.name;
    self.lblTo.text = offer.endLocation.name;
}

@end
