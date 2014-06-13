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
#import "CarPoolRequestClient.h"
#import "CarPoolRequest.h"

@interface CreateRequestStepsViewController() <DateTimePickerViewControllerDataSource, DateTimePickerViewControllerDelegate, LocationPickerViewControllerDataSource, LocationPickerViewControllerDelegate, MessagePickerViewControllerDelegate>
@property (nonatomic, strong) DateTimePickerViewController *dateTimePickerViewController;
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
    
    self.dateTimePickerViewController = [DateTimePickerViewController viewController];
    self.dateTimePickerViewController.delegate = self;
    self.dateTimePickerViewController.dataSource = self;
    
    self.locationPickerViewController = [LocationPickerViewController viewController];
    self.locationPickerViewController.delegate = self;
    self.locationPickerViewController.dataSource = self;
    
    self.messagePickerViewController = [MessagePickerViewController viewController];
    self.messagePickerViewController.delegate = self;
    
    if ([self.offer.period isEqualToNumber:CarPoolOfferPeriodOneTime])
    {
        self.request.date = self.offer.date;
        
        [self setStepViewControllers:@[self.locationPickerViewController,
                                       self.messagePickerViewController]];
    }
    else
    {
        [self setStepViewControllers:@[self.dateTimePickerViewController,
                                       self.locationPickerViewController,
                                       self.messagePickerViewController]];
    }
}

#pragma mark - DateTimePickerViewControllerDataSource & DateTimePickerViewControllerDelegate -

- (void)dateTimePickerViewControllerDidSelectDate:(NSDate *)date
{
    self.request.date = [date dateByCopyingTimeComponentsFromDate:self.offer.date];
}

- (UIDatePickerMode)datePickerModeForDateTimePickerViewController
{
    // We only ask for date if the request is on a weekly offer and has a time
    // So we don't need time, only date
    return UIDatePickerModeDate;
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

- (void)messagePickerViewControllerDidSelectSendWithMessage:(NSString *)message
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
    
    if (message == 0)
    {
        [self alertWithtitle:@"Error" andMessage:@"Message is required"];
        return;
    }
    
    [self showLoader];
    
    self.request.date = self.offer.date;
    self.request.from = [User currentUser];
    self.request.to = self.offer.from;
    self.request.offer = self.offer;
    self.request.message = message;
    
    [self.requestClient saveRequest:self.request withCompletion:^(NSError *error) {
        [self hideLoader];
        
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"There was a problem sending your offer"];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Your request was sent."
                                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"Ok"
                                                                                         action:^{
                                                                                             
                                                                                             [self.navigationController popViewControllerAnimated:YES];
                                                                                             [self.delegate createRequestStepsViewControllerDidCreateRequest:self.request];
                                                                                         }] otherButtonItems:nil];
            
            [alert show];
        }
    }];
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
