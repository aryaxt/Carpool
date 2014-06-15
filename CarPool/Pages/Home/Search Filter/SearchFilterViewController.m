//
//  SearchFilterViewController.m
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "SearchFilterViewController.h"
#import "LocationSearchViewController.h"
#import "UIViewController+Additions.h"
#import "LocationSearchViewController.h"

@interface SearchFilterViewController() <LocationSearchViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIPickerView *agePicker;
@property (nonatomic, strong) IBOutlet UITextField *txtFromLocation;
@property (nonatomic, strong) IBOutlet UITextField *txtToLocation;
@property (nonatomic, strong) IBOutlet UITextField *txtDate;
@property (nonatomic, strong) IBOutlet UITextField *txtAge;
@property (nonatomic, strong) NSArray *ageRanges;
@end

@implementation SearchFilterViewController

#define LOCATION_SEARCH_START @"LOCATION_SEARCH_START"
#define LOCATION_SEARCH_END @"LOCATION_SEARCH_END"
#define MIN_AGE 18
#define MAX_AGE 100

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self trackPage:GoogleAnalyticsManagerPageHomeSearchFilter];
    
    [self.datePicker removeFromSuperview];
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.date = [NSDate date];
    self.txtDate.inputView = self.datePicker;
    
    [self.agePicker removeFromSuperview];
    self.txtAge.inputView = self.agePicker;
    
    [self populateData];
}

#pragma mark - IBAction -

- (IBAction)datePickerChangedValue:(id)sender
{
    self.searchFilter.date = self.datePicker.date;
    [self populateData];
}

- (IBAction)clearFilterSelected:(id)sender
{
    self.searchFilter = [[SearchFilter alloc] init];
    [self populateData];
}

- (IBAction)applyFilterselected:(id)sender
{
    [self.delegate searchFilterViewControllerDidApplyFilter:self.searchFilter];
}

- (IBAction)genderSegmentedControlChanged:(id)sender
{
    switch (self.genderSegmentedControl.selectedSegmentIndex)
    {
        case 0:
        self.searchFilter.gender = @1;
        break;
        
        case 1:
        self.searchFilter.gender = nil;
        break;
        
        case 2:
        self.searchFilter.gender = @2;
        break;
    }
    
    [self populateData];
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtFromLocation || textField == self.txtToLocation)
    {
        LocationSearchViewController *vc = (LocationSearchViewController *) [LocationSearchViewController viewController];
        UINavigationController *nacVontroller = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.delegate = self;
        vc.tag = (textField == self.txtFromLocation) ? LOCATION_SEARCH_START : LOCATION_SEARCH_END;
        [self presentViewController:nacVontroller animated:YES completion:nil];
        
        return false;
    }
    
    return true;
}

#pragma mark - LocationSearchViewControllerDelegate -

- (void)locationSearchViewControllerDidSelectCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationSearchViewControllerDidSelectLocation:(Location *)location withTag:(NSString *)tag
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([tag isEqualToString:LOCATION_SEARCH_START])
    {
        self.searchFilter.startLocation = location;
    }
    else if ([tag isEqualToString:LOCATION_SEARCH_END])
    {
        self.searchFilter.endLocation = location;
    }
    
    [self populateData];
}

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return MAX_AGE - MIN_AGE;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld", row + MIN_AGE];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.searchFilter.minAge = @(row+MIN_AGE);
    }
    else
    {
        self.searchFilter.maxAge = @(row+MIN_AGE);
    }
    
    [self populateData];
}

#pragma mark - Private Methods -

- (void)populateData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    self.txtDate.text = [dateFormatter stringFromDate:self.searchFilter.date];
    self.txtFromLocation.text = self.searchFilter.startLocation.name;
    self.txtToLocation.text = self.searchFilter.endLocation.name;
    self.txtAge.text = [NSString stringWithFormat:@"%@ to %@ year old", self.searchFilter.minAge, self.searchFilter.maxAge];
    
    if (self.searchFilter.gender)
    {
        switch (self.searchFilter.gender.intValue)
        {
            case 1:
            self.genderSegmentedControl.selectedSegmentIndex = 0;
            break;
            
            case 2:
            self.genderSegmentedControl.selectedSegmentIndex = 2;
            break;
        }
    }
    else
    {
        self.genderSegmentedControl.selectedSegmentIndex = 1;
    }
}

#pragma mark - Touch Detection -

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self.txtDate resignFirstResponder];
    [self.txtAge resignFirstResponder];
}

@end
