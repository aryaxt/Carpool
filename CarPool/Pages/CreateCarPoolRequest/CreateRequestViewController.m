//
//  CreateCarPoolRequestViewController.m
//  CarPool
//
//  Created by Aryan on 5/10/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CreateRequestViewController.h"
#import "UIViewController+Additions.h"
#import "UIView+Additions.h"
#import "UIAlertView+Blocks.h"

@implementation CreateRequestViewController

#define LOCATION_SEARCH_START @"LOCATION_SEARCH_START"
#define LOCATION_SEARCH_END @"LOCATION_SEARCH_END"

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.request = [[CarPoolRequest alloc] init];
    
    self.txtMessage.text = @"";
}

#pragma mark - IBActions -

- (IBAction)sendSelected:(id)sender
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
    
    if (self.txtMessage.text.length == 0)
    {
        [self alertWithtitle:@"Error" andMessage:@"Message is required"];
        return;
    }
    
    [self showLoader];
    
    self.request.date = self.offer.date;
    self.request.from = [User currentUser];
    self.request.to = self.offer.from;
    self.request.offer = self.offer;
    self.request.message = self.txtMessage.text;
    
    [self.requestCleint saveRequest:self.request withCompletion:^(NSError *error) {
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
                                                                                             [self.delegate createRequestViewControllerDidCreateRequest:self.request];
                                                                                         }] otherButtonItems:nil];
            
            [alert show];
        }
    }];

}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtFrom || textField == self.txtTo)
    {
        LocationSearchViewController *vc = (LocationSearchViewController *) [LocationSearchViewController viewController];
        UINavigationController *nacVontroller = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.delegate = self;
        vc.tag = (textField == self.txtFrom) ? LOCATION_SEARCH_START : LOCATION_SEARCH_END;
        [self presentViewController:nacVontroller animated:YES completion:nil];
        
        return false;
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
        self.request.startLocation = location;
    }
    else if ([tag isEqualToString:LOCATION_SEARCH_END])
    {
        self.request.endLocation = location;
    }
    
    [self populateData];
}

#pragma mark - Private Methods -

- (void)populateData
{
    self.txtFrom.text = self.request.startLocation.name;
    self.txtTo.text = self.request.endLocation.name;
}

#pragma mark - Setter & Getter -

- (CarPoolRequestClient *)requestCleint
{
    if (!_requestCleint)
    {
        _requestCleint = [[CarPoolRequestClient alloc] init];
    }
    
    return _requestCleint;
}

@end
