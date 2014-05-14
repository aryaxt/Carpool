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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CreateRequestViewController"])
    {
        CreateRequestViewController *vc = (CreateRequestViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
        vc.delegate = self;
        vc.offer = self.carPoolOffer;
    }
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

#pragma mark - CreateRequestViewControllerDelegate -

- (void)createRequestViewControllerDidSelectCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createRequestViewControllerDidCreateOffer:(CarPoolOffer *)offr
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self alertWithtitle:@"Yay" andMessage:@"Offer was created"];
}

#pragma mark - Setter & Getter -

- (void)setCarPoolOffer:(CarPoolOffer *)offer
{
    _carPoolOffer = offer;
    
    self.btnTitle.title = offer.from.name;
    [self.offerOwnerPhoto setImageWithURL:[NSURL URLWithString:offer.from.photoUrl]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    self.lblDate.text = [dateFormatter stringFromDate:offer.time];
    self.lblStartLocation.text = offer.startLocation.name;
    self.lblEndLocation.text = offer.endLocation.name;
    self.lblMessage.text = offer.message;
}

@end
