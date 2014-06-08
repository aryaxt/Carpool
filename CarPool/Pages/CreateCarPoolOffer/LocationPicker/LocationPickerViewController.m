//
//  LocationPickerViewController.m
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "LocationPickerViewController.h"
#import "UIViewController+Additions.h"
#import "LocationSearchViewController.h"

@interface LocationPickerViewController() <LocationSearchViewControllerDelegate>
@property (nonatomic, strong) IBOutlet UITextField *txtStartLocation;
@property (nonatomic, strong) IBOutlet UITextField *txtEndLocaton;
@end

@implementation LocationPickerViewController

#define LOCATION_SEARCH_START @"LOCATION_SEARCH_START"
#define LOCATION_SEARCH_END @"LOCATION_SEARCH_END"

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    LocationSearchViewController *vc = (LocationSearchViewController *) [LocationSearchViewController viewController];
    UINavigationController *nacVontroller = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.delegate = self;
    vc.tag = (textField == self.txtStartLocation) ? LOCATION_SEARCH_START : LOCATION_SEARCH_END;
    
    UIViewController *modalPresenter = [self.dataSource modalPresenterForLocationPickerViewController];
    [modalPresenter presentViewController:nacVontroller animated:YES completion:nil];
    
    return NO;
}

#pragma mark - LocationSearchViewControllerDelegate -

- (void)locationSearchViewControllerDidSelectCancel
{
    UIViewController *modalPresenter = [self.dataSource modalPresenterForLocationPickerViewController];
    [modalPresenter dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationSearchViewControllerDidSelectLocation:(Location *)location withTag:(NSString *)tag
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([tag isEqualToString:LOCATION_SEARCH_START])
    {
        [self.delegate locationPickerViewControllerDidSelectStartLocation:location];
        self.txtStartLocation.text = location.name;
    }
    else if ([tag isEqualToString:LOCATION_SEARCH_END])
    {
        [self.delegate locationPickerViewControllerDidSelectEndLocation:location];
        self.txtEndLocaton.text = location.name;
    }
    
    UIViewController *modalPresenter = [self.dataSource modalPresenterForLocationPickerViewController];
    [modalPresenter dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - StepViewController Methods -

- (BOOL)isStepValid
{
    return (self.txtEndLocaton.text.length > 0 && self.txtStartLocation.text.length > 0);
}

- (NSString *)validationError
{
    if (self.txtStartLocation.text.length == 0)
        return @"Please select a starting location";
    
    if (self.txtEndLocaton.text.length == 0)
        return @"Please select an ending location";
    
    return nil;
}

@end
