//
//  PeriodPickerViewController.m
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "PeriodPickerViewController.h"
#import "CarPoolOffer.h"

@interface PeriodPickerViewController()
@property (nonatomic, strong) NSNumber *selectedPeriod;
@property (nonatomic, weak) IBOutlet UIButton *btnOneTime;
@property (nonatomic, weak) IBOutlet UIButton *btnWeekDay;
@end

@implementation PeriodPickerViewController

#pragma mark - IBActions -

- (IBAction)oneTimePeriodSelected:(id)sender
{
    self.selectedPeriod = CarPoolOfferPeriodOneTime;
    [self.delegate periodPickerViewControllerDidSelectPeriod:self.selectedPeriod];
}

- (IBAction)weekDaysPeriodSelected:(id)sender
{
    self.selectedPeriod = CarPoolOfferPeriodWeekDays;
    [self.delegate periodPickerViewControllerDidSelectPeriod:self.selectedPeriod];
}

#pragma mark - StepViewController Methods -

- (BOOL)isStepValid
{
    return (self.selectedPeriod) ? YES : NO;
}

- (NSString *)validationError
{
    return (self.selectedPeriod) ? nil : @"Please provide a valid period for this offer";
}

@end
