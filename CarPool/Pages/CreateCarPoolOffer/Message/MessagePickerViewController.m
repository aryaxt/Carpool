//
//  MessagePickerViewController.m
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MessagePickerViewController.h"

@implementation MessagePickerViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.txtMessage.text = @"";
    self.txtMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txtMessage.layer.borderWidth = .6;
}

#pragma mark - StepViewController Methods -

- (BOOL)isStepValid
{
    return (self.txtMessage.text.length > 0);
}

- (NSString *)validationError
{
    if (self.txtMessage.text.length == 0)
        return @"Please write a message, this will improve your chances of gettin your request accepted";
    
    return nil;
}

- (void)stepWillAppear
{
    [self.txtMessage becomeFirstResponder];
}

#pragma mark - IBActions -

- (IBAction)createSelected:(id)sender
{
    [self.txtMessage resignFirstResponder];
    [self.delegate messagePickerViewControllerDidSelectSendWithMessage:self.txtMessage.text];
}

@end
