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

@implementation CreateOfferViewController

#pragma - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.datePicker removeFromSuperview];
    self.datePicker.minimumDate = [NSDate date];
    self.dateTextField.inputView = self.datePicker;
}

#pragma - IBActions -

- (IBAction)createSelected:(id)sender
{
    //Period *period = [[Period alloc] init];
    
    CarPoolOffer *offer = [[CarPoolOffer alloc] init];
    offer.date = self.datePicker.date;
    offer.startPoint = [PFGeoPoint geoPointWithLocation:[LocationManager sharedInstance].currentLocation];
    offer.endPoint = [PFGeoPoint geoPointWithLocation:[LocationManager sharedInstance].currentLocation];
    //offer.period = period;
    [offer.user addObject:[PFUser currentUser]];
    
    
    /*[offer setValue:self.datePicker.date forKey:@"date"];
    [offer setValue:[PFGeoPoint geoPointWithLocation:[LocationManager sharedInstance].currentLocation] forKey:@"startPoiint"];
    [offer setValue:[PFGeoPoint geoPointWithLocation:[LocationManager sharedInstance].currentLocation] forKey:@"endPoint"];
    [offer setObject:[PFUser currentUser] forKey:@"user"];
    [offer setObject:period forKey:@"period"];*/

    
    [offer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            //TODO: Show error
        }
    }];
}

- (IBAction)cancelSelected:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self.dateTextField resignFirstResponder];
}

@end
