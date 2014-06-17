//
//  OfferDetailViewController.m
//  CarPool
//
//  Created by Aryan on 6/15/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "OfferDetailViewController.h"
#import "CarPoolOfferClient.h"

@interface OfferDetailViewController ()
@property (nonatomic, strong) IBOutlet UILabel *lblStartLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblEndLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIButton *btnDeactivate;
@property (nonatomic, strong) CarPoolOfferClient *offerClient;
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

#pragma mark - IBAction -

- (IBAction)deactivateSelected:(id)sender
{
    [self showLoader];
    
    [self.offerClient deactivateOffer:self.offer withCompletion:^(NSError *error) {
        
        [self hideLoader];
        
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"There was a problem deactivating this offer."];
        }
        else
        {
            self.btnDeactivate.hidden = YES;
            [self.delegate offerDetailViewControllerDidDeactivateOffer:self.offer];
        }
    }];
}

#pragma mark - Setter & Gtter -

- (CarPoolOfferClient *)offerClient
{
    if (!_offerClient)
    {
        _offerClient = [[CarPoolOfferClient alloc] init];
    }
    
    return _offerClient;
}

@end
