//
//  OfferDetailViewController.m
//  CarPool
//
//  Created by Aryan on 5/9/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "OfferDetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "CreateRequestViewController.h"

@implementation OfferDetailViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.view addGestureRecognizer:panRecognizer];
}

#pragma mark - GestureRecognizer -

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    [self.delegate offerDetailViewControllerDidDetectPan:panRecognizer];
}

#pragma mark - IBActions -

- (IBAction)nextSelected:(id)sender
{
    [self.delegate offerDetailViewControllerDidSelectNext];
}

- (IBAction)previousSelected:(id)sender
{
    [self.delegate offerDetailViewControllerDidSelectPrevious];
}

- (IBAction)titleSelected:(id)sender
{
    [self.delegate offerDetailViewControllerDidSelectExpand];
}

- (IBAction)requestOfferSelected:(id)sender
{
    [self.delegate offerDetailViewControllerDidSelectRequestForOffer:self.carPoolOffer];
}

- (IBAction)viewProfileSelected:(id)sender
{
    [self.delegate offerDetailViewControllerDidSelectViewUserProfile:self.carPoolOffer.from];
}

#pragma mark - Setter & Getter -

- (void)setCarPoolOffer:(CarPoolOffer *)offer
{
    _carPoolOffer = offer;
    
    self.btnTitle.title = offer.from.name;
    [self.offerOwnerPhoto setImageWithURL:[NSURL URLWithString:offer.from.photoUrl]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:([offer.period isEqual:CarPoolOfferPeriodOneTime])
        ? @"yyyy-MM-dd hh:mm a"
        : @"hh:mm a"];
    
    self.lblDate.text = [dateFormatter stringFromDate:offer.date];
    self.lblStartLocation.text = offer.startLocation.name;
    self.lblEndLocation.text = offer.endLocation.name;
    self.lblMessage.text = offer.message;
}

@end
