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

@implementation CreateOfferViewController

#define LOCATION_SEARCH_START @"LOCATION_SEARCH_START"
#define LOCATION_SEARCH_END @"LOCATION_SEARCH_END"

#pragma - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.offer = [[CarPoolOffer alloc] init];
    self.offer.user = [PFUser currentUser];
    self.offer.time = [NSDate date];
    
    [self.datePicker removeFromSuperview];
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.date = [NSDate date];
    self.txtDate.inputView = self.datePicker;
    self.txtMessage.text = @"";
    
    [self populateData];
}

#pragma - Private Methods -

- (void)populateData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    self.txtDate.text = [dateFormatter stringFromDate:self.offer.time];
    
    if (self.offer.startLocation)
    {
        self.txtStartLocation.text = self.offer.startLocation.name;
    }
    
    if (self.offer.endLocation)
    {
        self.txtEndLocation.text = self.offer.endLocation.name;
    }
}

#pragma - IBActions -

- (IBAction)createSelected:(id)sender
{
    self.offer.message = self.txtMessage.text;
    
    if (!self.offer.startLocation)
    {
        [self alertWithtitle:@"Error" andMessage:@"Starting location is required"];
    }
    
    if (!self.offer.endLocation)
    {
        [self alertWithtitle:@"Error" andMessage:@"Ending location is required"];
    }
    [self showLoader];
    
    [self.offerClient createOffer:self.offer withCompletion:^(BOOL succeeded, NSError *error) {
        [self hideLoader];
        
        if (succeeded)
        {
            [self.delegate createOfferViewControllerDidCreateOffer:self.offer];
        }
        else
        {
            [self alertWithtitle:@"Error" andMessage:@"There was a problem creating this offer"];
        }
    }];
}

- (IBAction)cancelSelected:(id)sender
{
    [self.delegate createOfferViewControllerDidSelectCancel];
}

- (IBAction)segmentedControlChanged:(id)sender
{
    if (self.periodSegmentedControl.selectedSegmentIndex == 0)
    {
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    else
    {
        self.datePicker.datePickerMode = UIDatePickerModeTime;
    }
}

- (IBAction)datePickerChangedValue:(id)sender
{
    self.offer.time = self.datePicker.date;
    
    [self populateData];
}

#pragma - Touch Detection -

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self.txtDate resignFirstResponder];
}

#pragma - UITextFieldDelegate -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtStartLocation || textField == self.txtEndLocation)
    {
        LocationSearchViewController *vc = (LocationSearchViewController *) [LocationSearchViewController viewController];
        vc.delegate = self;
        vc.tag = (textField == self.txtStartLocation) ? LOCATION_SEARCH_START : LOCATION_SEARCH_END;
        [self presentViewController:vc animated:YES completion:nil];
        
        return false;
    }
    
    return true;
}

#pragma - LocationSearchViewControllerDelegate -

- (void)locationSearchViewControllerDidSelectCance
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationSearchViewControllerDidSelectPlace:(SPGooglePlacesAutocompletePlace *)place withTag:(NSString *)tag
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([tag isEqualToString:LOCATION_SEARCH_START])
    {
        self.offer.startLocation = [Location locationFrom:place];
    }
    else if ([tag isEqualToString:LOCATION_SEARCH_END])
    {
        self.offer.endLocation = [Location locationFrom:place];
    }
    
    [self populateData];
}

#pragma - Setter & Getter -

- (CarPoolOfferClient *)offerClient
{
    if (!_offerClient)
    {
        _offerClient = [[CarPoolOfferClient alloc] init];
    }
    
    return _offerClient;
}

@end
