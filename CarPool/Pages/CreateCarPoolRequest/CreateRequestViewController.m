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

@implementation CreateRequestViewController

#define LOCATION_SEARCH_START @"LOCATION_SEARCH_START"
#define LOCATION_SEARCH_END @"LOCATION_SEARCH_END"
#define KEYBOARD_PORTRAIT_HEIGHT 216
#define NAVIGATION_BAR_HEIGHT 64
#define MESSAGE_TEXT_VIEW_OFFSET 6

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.request = [[CarPoolRequest alloc] init];
    
    self.txtMessage.text = @"";
    
    self.btnCloseMessage.hidden = YES;
    self.btnCloseMessage.transform = CGAffineTransformScale(self.btnCloseMessage.transform, .1, .1);
    self.messageViewOriginalFrame = self.messageView.frame;
    self.messageView.backgroundColor = [UIColor clearColor];
    
    self.txtMessage.layer.borderWidth = .6;
    self.txtMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txtMessage.layer.cornerRadius = 5;
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
    
    [self showLoader];
    
    self.request.time = self.offer.time;
    self.request.from = [User currentUser];
    self.request.to = self.offer.from;
    self.request.offer = self.offer;
    
    Comment *comment = [[Comment alloc] init];
    comment.from = [User currentUser];
    comment.to = self.offer.from;
    comment.message = self.txtMessage.text;
    
    [self.requestEngine createRequest:self.request withInitialComment:comment andCompletion:^(NSError *error) {
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"There was a problem sending your offer"];
        }
        else
        {
            [self.delegate createRequestViewControllerDidCreateOffer:self.offer];
        }
    }];
}

- (IBAction)cancelSelected:(id)sender
{
    [self.delegate createRequestViewControllerDidSelectCancel];
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

#pragma mark - Setter & Gettr -

- (CarPoolRequestEngine *)requestEngine
{
    if (!_requestEngine)
    {
        _requestEngine = [[CarPoolRequestEngine alloc] init];
    }
    
    return _requestEngine;
}

@end
