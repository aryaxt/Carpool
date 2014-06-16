//
//  OfferDetailViewController.m
//  CarPool
//
//  Created by Aryan on 6/15/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "OfferDetailViewController.h"

@interface OfferDetailViewController ()
@property (nonatomic, strong) IBOutlet UILabel *lblStartLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblEndLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@end

@implementation OfferDetailViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:([self.offer.period isEqual:CarPoolOfferPeriodOneTime])
      ? @"yyyy-MM-dd hh:mm a"
      : @"hh:mm a"];
    
    self.lblDate.text = [dateFormatter stringFromDate:self.offer.date];
    self.lblStartLocation.text = self.offer.startLocation.name;
    self.lblEndLocation.text = self.offer.endLocation.name;
}

@end
