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
#import "User.h"

@implementation CreateOfferViewController

#define LOCATION_SEARCH_START @"LOCATION_SEARCH_START"
#define LOCATION_SEARCH_END @"LOCATION_SEARCH_END"
#define KEYBOARD_PORTRAIT_HEIGHT 216
#define NAVIGATION_BAR_HEIGHT 64
#define MESSAGE_TEXT_VIEW_OFFSET 6

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.offer = [[CarPoolOffer alloc] init];
    
    [self.datePicker removeFromSuperview];
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.date = [NSDate date];
    self.txtDate.inputView = self.datePicker;
    self.txtMessage.text = @"";
    
    self.btnCloseMessage.hidden = YES;
    self.btnCloseMessage.transform = CGAffineTransformScale(self.btnCloseMessage.transform, .1, .1);
    self.messageViewOriginalFrame = self.messageView.frame;
    self.messageView.backgroundColor = [UIColor clearColor];
    
    self.txtMessage.layer.borderWidth = .6;
    self.txtMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txtMessage.layer.cornerRadius = 5;
    
    [self populateData];
}

#pragma mark - Private Methods -

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

- (IBAction)closeMessageSelected:(id)sender
{
    [self.btnCloseMessage animateShrinkWithCompletion:^{
        [UIView animateWithDuration:.3 animations:^{
            self.btnCloseMessage.hidden = YES;
            self.messageView.frame = self.messageViewOriginalFrame;
        }completion:^(BOOL finished) {
            [self.txtMessage resignFirstResponder];
        }];
    }];
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
        
        return false;
    }
    
    return true;
}

#pragma mark - UITextViewDelegate -

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect rect = CGRectMake(0,
                             MESSAGE_TEXT_VIEW_OFFSET + NAVIGATION_BAR_HEIGHT,
                             self.messageView.frame.size.width,
                             self.view.frame.size.height - KEYBOARD_PORTRAIT_HEIGHT - (MESSAGE_TEXT_VIEW_OFFSET * 2) - NAVIGATION_BAR_HEIGHT);
    
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.messageView.frame = rect;
    } completion:^(BOOL finished) {

        self.btnCloseMessage.hidden = NO;
        [self.btnCloseMessage animatePopWithCompletion:nil];
    }];
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
