//
//  OfferDetailViewController.m
//  CarPool
//
//  Created by Aryan on 5/9/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "OfferDetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation OfferDetailViewController

#pragma - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.view addGestureRecognizer:panRecognizer];
}

#pragma - GestureRecognizer -

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    [self.delegate offerDetailViewControllerDidDetectPan:panRecognizer];
}

#pragma - IBActions -

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

#pragma - Setter & Getter -

- (void)setCarPoolOffer:(CarPoolOffer *)offer
{
    _carPoolOffer = offer;
    
    self.btnTitle.title = offer.user.name;
    [self.offerOwnerPhoto setImageWithURL:[NSURL URLWithString:offer.user.photoUrl]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    self.lblDate.text = [dateFormatter stringFromDate:offer.time];
    self.lblStartLocation.text = offer.startLocation.name;
    self.lblEndLocation.text = offer.endLocation.name;
    self.lblMessage.text = offer.message;
}

@end
