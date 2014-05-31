//
//  CreateOfferViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CreateOfferViewController.h"
#import "CarPoolOffer.h"
#import <Parse/PFGeoPoint.h>
#import "LocationManager.h"
#import "LocationSearchViewController.h"
#import "UIViewController+Additions.h"
#import "UIView+Additions.h"
#import "UIAlertView+Blocks.h"
#import "User.h"

@implementation CreateOfferViewController

#define LOCATION_SEARCH_START @"LOCATION_SEARCH_START"
#define LOCATION_SEARCH_END @"LOCATION_SEARCH_END"

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.offer = [[CarPoolOffer alloc] init];
    
    [self.datePicker removeFromSuperview];
    self.datePicker.date = [NSDate date];
    self.txtDate.inputView = self.datePicker;
    self.txtMessage.text = @"";
    
    [self populateData];
}

#pragma mark - Private Methods -

- (void)populateData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:([self.offer.period isEqual:CarPoolOfferPeriodOneTime])
        ? @"yyyy-MM-dd hh:mm a"
        : @"hh:mm a"];

    self.txtDate.text = [dateFormatter stringFromDate:self.offer.date];
    
    if (self.offer.startLocation)
    {
        self.txtStartLocation.text = self.offer.startLocation.name;
    }
    
    if (self.offer.endLocation)
    {
        self.txtEndLocation.text = self.offer.endLocation.name;
    }
}

#pragma mark - IBActions -

- (IBAction)createSelected:(id)sender
{
    self.offer.message = self.txtMessage.text;
    self.offer.from = [User currentUser];
    
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Your offer was created."
                                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"Ok"
                                                                                         action:^{
                                                                                             
                                                                                             [self.navigationController popViewControllerAnimated:YES];
                                                                                             [self.delegate createOfferViewControllerDidCreateOffer:self.offer];
                                                                                         }] otherButtonItems:nil];
            
            [alert show];
        }
        else
        {
            [self alertWithtitle:@"Error" andMessage:@"There was a problem creating this offer"];
        }
    }];
}

- (IBAction)segmentedControlChanged:(id)sender
{
    if (self.periodSegmentedControl.selectedSegmentIndex == 0)
    {
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.offer.period = CarPoolOfferPeriodOneTime;
    }
    else
    {
        self.datePicker.minimumDate =  nil;
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        self.offer.period = CarPoolOfferPeriodWeekDays;
    }
    
    [self populateData];
}

- (IBAction)datePickerChangedValue:(id)sender
{
    self.offer.date = self.datePicker.date;
    
    [self populateData];
}

#pragma mark - Touch Detection -

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self.txtDate resignFirstResponder];
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtStartLocation || textField == self.txtEndLocation)
    {
        LocationSearchViewController *vc = (LocationSearchViewController *) [LocationSearchViewController viewController];
        UINavigationController *nacVontroller = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.delegate = self;
        vc.tag = (textField == self.txtStartLocation) ? LOCATION_SEARCH_START : LOCATION_SEARCH_END;
        [self presentViewController:nacVontroller animated:YES completion:nil];
        
        return NO;
    }
    else if (textField == self.txtDate)
    {
        if (!self.offer.period)
        {
            [self alertWithtitle:@"Error" andMessage:@"Please select a period before seting a date"];
            return NO;
        }
        
        return YES;
    }
    
    return true;
}

#pragma mark - LocationSearchViewControllerDelegate -

- (void)locationSearchViewControllerDidSelectCance
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationSearchViewControllerDidSelectLocation:(Location *)location withTag:(NSString *)tag
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([tag isEqualToString:LOCATION_SEARCH_START])
    {
        self.offer.startLocation = location;
    }
    else if ([tag isEqualToString:LOCATION_SEARCH_END])
    {
        self.offer.endLocation = location;
    }
    
    [self populateData];
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
