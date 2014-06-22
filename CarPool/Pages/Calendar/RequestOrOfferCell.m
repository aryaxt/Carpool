//
//  RequestOrOfferCell.m
//  CarPool
//
//  Created by Aryan on 6/22/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "RequestOrOfferCell.h"

@interface RequestOrOfferCell()
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@end

@implementation RequestOrOfferCell

- (void)setOffer:(CarPoolOffer *)offer
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    self.lblTime.text = [dateFormatter stringFromDate:offer.date];
}

- (void)setRequest:(CarPoolRequest *)request
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    self.lblTime.text = [dateFormatter stringFromDate:request.date];
}

@end
