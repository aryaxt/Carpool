//
//  CreateRequestStepsViewController.m
//  CarPool
//
//  Created by Aryan on 6/13/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CreateRequestStepsViewController.h"
#import "UIViewController+Additions.h"
#import "NSDate+Additions.h"
#import "UIAlertView+Blocks.h"
#import "DateTimePickerViewController.h"
#import "LocationPickerViewController.h"
#import "MessagePickerViewController.h"
#import "PeriodPickerViewController.h"
#import "CarPoolRequestClient.h"
#import "CarPoolRequest.h"

@interface CreateRequestStepsViewController() <DateTimePickerViewControllerDataSource, DateTimePickerViewControllerDelegate, LocationPickerViewControllerDataSource, LocationPickerViewControllerDelegate, MessagePickerViewControllerDelegate, PeriodPickerViewControllerDelegate>
@property (nonatomic, strong) DateTimePickerViewController *dateTimePickerViewController;
@property (nonatomic, strong) PeriodPickerViewController *periodPickerViewController;
@property (nonatomic, strong) LocationPickerViewController *locationPickerViewController;
@property (nonatomic, strong) MessagePickerViewController *messagePickerViewController;
@property (nonatomic, strong) CarPoolRequestClient *requestClient;
@property (nonatomic, strong) CarPoolRequest *request;
@end

@implementation CreateRequestStepsViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.request = [[CarPoolRequest alloc] init];
    
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
    
    
    NSMutableArray *steps = [NSMutableArray array];
    
    if (!self.offer)
        [steps addObject:self.periodPickerViewController];
    
    if (!self.offer || [self.offer.period isEqualToNumber:CarPoolOfferPeriodWeekDays])
        [steps addObject:self.dateTimePickerViewController];
    else
        self.request.date = self.offer.date;
    
    [steps addObject:self.locationPickerViewController];
    
    if (self.offer)
        [steps addObject:self.messagePickerViewController];
    
    [self setStepViewControllers:steps];
    
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
    [self.delegate createRequestStepsViewControllerDidSelectCancel];
}

- (void)sendSelected:(id)sender

{
    if (!self.request.startLocation)
    {
        [self alertWithtitle:@"Error" andMessage:@"Starting location is required"];
        return;
    }
    
    if (!self.request.endLocation)
    {
        [self alertWithtitle:@"Error" andMessage:@"Ending location is required"];
        return;
    }
    
    if (self.offer && self.request.message.length == 0)
    {
        [self alertWithtitle:@"Error" andMessage:@"Message is required"];
        return;
    }
    
    [self showLoader];
    
    self.request.from = [User currentUser];
    self.request.to = self.offer.from;
    self.request.offer = self.offer;
    
    [self.requestClient saveRequest:self.request withCompletion:^(NSError *error) {
        [self hideLoader];
        
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"There was a problem sending your offer"];
        }
        else
        {
            [self.delegate createRequestStepsViewControllerDidCreateRequest:self.request];
        }
    }];
}

#pragma mark - DateTimePickerViewControllerDataSource & DateTimePickerViewControllerDelegate -

- (void)dateTimePickerViewControllerDidSelectDate:(NSDate *)date
{
    self.request.date = (self.offer) ? [date dateByCopyingTimeComponentsFromDate:self.offer.date] : date;
}

- (UIDatePickerMode)datePickerModeForDateTimePickerViewController
{
    if (self.offer)
    {
        // ModeDate for Weekly, and no date picker at all for daily
        return UIDatePickerModeDate;
    }
    else
    {
        if ([self.request.period isEqual:CarPoolOfferPeriodOneTime])
            return UIDatePickerModeDateAndTime;
        else
            return UIDatePickerModeTime;
    }

    return UIDatePickerModeDate;
}

#pragma mark - PeriodPickerViewControllerDelegate -

- (void)periodPickerViewControllerDidSelectPeriod:(NSNumber *)period
{
    self.request.period = period;
    [self moveToNextStep];
}

#pragma mark - LocationPickerViewControllerDelegate & LocationPickerViewControllerDataSource -

- (void)locationPickerViewControllerDidSelectStartLocation:(Location *)location
{
    self.request.startLocation = location;
}

- (void)locationPickerViewControllerDidSelectEndLocation:(Location *)location
{
    self.request.endLocation = location;
}

- (UIViewController *)modalPresenterForLocationPickerViewController
{
    return self;
}

#pragma mark - MessagePickerViewControllerDelegate -

- (void)messagePickerViewControllerDidEnterMessage:(NSString *)message
{
    self.request.message = message;
}

#pragma mark - Setter & Getter -

- (CarPoolRequestClient *)requestClient
{
    if (!_requestClient)
    {
        _requestClient = [[CarPoolRequestClient alloc] init];
    }
    
    return _requestClient;
}


@end
