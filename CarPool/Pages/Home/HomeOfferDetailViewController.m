//
//  OfferDetailViewController.m
//  CarPool
//
//  Created by Aryan on 5/9/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "HomeOfferDetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "CreateRequestStepsViewController.h"

@interface HomeOfferDetailViewController()
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblStartLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblEndLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblUserName;
@property (nonatomic, strong) IBOutlet UITextView *lblMessage;
@property (nonatomic, strong) IBOutlet UIImageView *offerOwnerPhoto;
@property (nonatomic, strong) IBOutlet UIView *topView;
@end

@implementation HomeOfferDetailViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    
    self.topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.topView.layer.borderWidth = .6;
    self.topView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.topView.layer.shadowRadius = 2;
    self.topView.layer.shadowOpacity = .4;
    self.topView.layer.shadowOffset = CGSizeMake(1, 1);
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topBarSelected:)];
    [self.lblUserName addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.view addGestureRecognizer:panRecognizer];
}

#pragma mark - GestureRecognizer -

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    [self.delegate homeOfferDetailViewControllerDidDetectPan:panRecognizer];
}

#pragma mark - IBActions -

- (IBAction)nextSelected:(id)sender
{
    [self.delegate homeOfferDetailViewControllerDidSelectNext];
}

- (IBAction)previousSelected:(id)sender
{
    [self.delegate homeOfferDetailViewControllerDidSelectPrevious];
}

- (IBAction)topBarSelected:(id)sender
{
    [self.delegate homeOfferDetailViewControllerDidSelectExpand];
}

- (IBAction)requestOfferSelected:(id)sender
{
    [self.delegate homeOfferDetailViewControllerDidSelectRequestForOffer:self.carPoolOffer];
}

- (IBAction)viewProfileSelected:(id)sender
{
    [self.delegate homeOfferDetailViewControllerDidSelectViewUserProfile:self.carPoolOffer.from];
}

#pragma mark - Setter & Getter -

- (void)setCarPoolOffer:(CarPoolOffer *)offer
{
    _carPoolOffer = offer;
    
    self.lblUserName.text = offer.from.name;
    [self.offerOwnerPhoto setImageWithURL:[NSURL URLWithString:offer.from.photoUrl] placeholderImage:[UIImage imageNamed:USER_PHOTO_PLACEHOLDER]];
    
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
