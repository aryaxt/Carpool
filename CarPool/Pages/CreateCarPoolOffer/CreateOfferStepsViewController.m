//
//  CreateOfferStepsViewController.m
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CreateOfferStepsViewController.h"
#import "UIViewController+Additions.h"
#import "PeriodPickerViewController.h"
#import "DateTimePickerViewController.h"
#import "LocationPickerViewController.h"
#import "MessagePickerViewController.h"
#import "UIAlertView+Blocks.h"
#import "CarPoolOfferClient.h"
#import "CarPoolOffer.h"

@interface CreateOfferStepsViewController() <PeriodPickerViewControllerDelegate, DateTimePickerViewControllerDataSource, DateTimePickerViewControllerDelegate, LocationPickerViewControllerDataSource, LocationPickerViewControllerDelegate, MessagePickerViewControllerDelegate>
@property (nonatomic, strong) PeriodPickerViewController *periodPickerViewController;
@property (nonatomic, strong) DateTimePickerViewController *dateTimePickerViewController;
@property (nonatomic, strong) LocationPickerViewController *locationPickerViewController;
@property (nonatomic, strong) MessagePickerViewController *messagePickerViewController;
@property (nonatomic, strong) CarPoolOfferClient *offerClient;
@property (nonatomic, strong) CarPoolOffer *offer;
@end

@implementation CreateOfferStepsViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.offer = [[CarPoolOffer alloc] init];
    
    self.periodPickerViewController = [PeriodPickerViewController viewController];
    self.periodPickerViewController.delegate = self;
    
    self.dateTimePickerViewController = [DateTimePickerViewController viewController];
    self.dateTimePickerViewController.delegate = self;
    self.dateTimePickerViewController.dataSource = self;
    
    self.locationPickerViewController = [LocationPickerViewController viewController];
    self.locationPickerViewController.delegate = self;
    self.locationPickerViewController.dataSource = self;
    
    self.messagePickerViewController = [MessagePickerViewController viewController];
    self.messagePickerViewController.delegate = self;
    
    [self setStepViewControllers:@[self.periodPickerViewController,
                                   self.dateTimePickerViewController,
                                   self.locationPickerViewController,
                                   self.messagePickerViewController]];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(cancelSelected:)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                action:@selector(sendSelected:)];
    self.navigationItem.rightBarButtonItem = sendItem;
}

#pragma mark - IBActions -

- (void)cancelSelected:(id)sender
{
    [self.delegate createOfferStepsViewControllerDidSelectCancel];
}

- (void)sendSelected:(id)sender
{
    self.offer.from = [User currentUser];
    self.offer.isActive = @YES;
    
    if (!self.offer.startLocation)
    {
        [self alertWithtitle:@"Error" andMessage:@"Starting location is required"];
        return;
    }
    
    if (!self.offer.endLocation)
    {
        [self alertWithtitle:@"Error" andMessage:@"Ending location is required"];
        return;
    }
    
    [self showLoader];
    
    [self.offerClient createOffer:self.offer withCompletion:^(BOOL succeeded, NSError *error) {
        [self hideLoader];
        
        if (succeeded)
        {
           [self.delegate createOfferStepsViewControllerDidCreateOffer:self.offer];
        }
        else
        {
            [self alertWithtitle:@"Error" andMessage:@"There was a problem creating this offer"];
        }
    }];
}

#pragma mark - PeriodPickerViewControllerDelegate -

- (void)periodPickerViewControllerDidSelectPeriod:(NSNumber *)period
{
    self.offer.period = period;
    [self moveToNextStep];
}

#pragma mark - DateTimePickerViewControllerDataSource & DateTimePickerViewControllerDelegate -

- (void)dateTimePickerViewControllerDidSelectDate:(NSDate *)date
{
    self.offer.date = date;
}

- (UIDatePickerMode)datePickerModeForDateTimePickerViewController
{
    if ([self.offer.period isEqual:CarPoolOfferPeriodOneTime])
        return UIDatePickerModeDateAndTime;
    else
        return UIDatePickerModeTime;
}

#pragma mark - LocationPickerViewControllerDelegate & LocationPickerViewControllerDataSource -

- (void)locationPickerViewControllerDidSelectStartLocation:(Location *)location
{
    self.offer.startLocation = location;
}

- (void)locationPickerViewControllerDidSelectEndLocation:(Location *)location
{
    self.offer.endLocation = location;
}

- (UIViewController *)modalPresenterForLocationPickerViewController
{
    return self;
}

#pragma mark - MessagePickerViewControllerDelegate -

- (void)messagePickerViewControllerDidEnterMessage:(NSString *)message
{
    self.offer.message = message;
}

#pragma mark - Setter & Getter -

- (CarPoolOfferClient *)offerClient
{
    if (!_offerClient)
    {
        _offerClient = [[CarPoolOfferClient alloc] init];
    }
    
    return _offerClient;
}

@end
