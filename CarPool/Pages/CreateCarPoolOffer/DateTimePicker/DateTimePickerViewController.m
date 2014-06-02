//
//  DateTimePickerViewController.m
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "DateTimePickerViewController.h"
#import "CarPoolOffer.h"

@interface DateTimePickerViewController ()

@end

@implementation DateTimePickerViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - StepViewController Methods -

- (BOOL)isStepValid
{
    return YES;
}

- (NSString *)validationError
{
    return nil;
}

- (void)stepWillAppear
{
    NSNumber *selectedPeriod = [self.dataSource periodForDateTimePickerViewController];
    
    if ([selectedPeriod isEqual:CarPoolOfferPeriodOneTime])
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    else
        self.datePicker.datePickerMode = UIDatePickerModeTime;
}

- (void)stepWillDisappear
{
    [self.delegate dateTimePickerViewControllerDidSelectDate:self.datePicker.date];
}

@end
