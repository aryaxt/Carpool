//
//  ReferencesViewController.m
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ReferencesViewController.h"
#import "UIViewController+Additions.h"

@implementation ReferencesViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.negativeReferenceViewController.view];
    [self.view addSubview:self.positiveReferenceViewController.view];
}


#pragma mark - IBActions -

- (IBAction)segmentedControlDidChange:(id)sender
{
    CGRect positiveReferenceRect = self.positiveReferenceViewController.view.frame;
    CGRect negativeReferenceRect = self.negativeReferenceViewController.view.frame;
    
    positiveReferenceRect.origin.x = (self.segmentedControl.selectedSegmentIndex == 0) ? 0 : self.view.frame.size.width*-1;
    negativeReferenceRect.origin.x = (self.segmentedControl.selectedSegmentIndex == 1) ? 0 : self.view.frame.size.width;
    
    [UIView animateWithDuration:.25
                          delay:
     0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.positiveReferenceViewController.view.frame = positiveReferenceRect;
        self.negativeReferenceViewController.view.frame = negativeReferenceRect;
    } completion:nil];
}

#pragma mark - Setter & Getter -

- (ReferenceViewController *)positiveReferenceViewController
{
    if (!_positiveReferenceViewController)
    {
        _positiveReferenceViewController = [ReferenceViewController viewController];
        _positiveReferenceViewController.referenceType = ReferenceTypePositive;
        _positiveReferenceViewController.user = self.user;
        _positiveReferenceViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    }
    
    return _positiveReferenceViewController;
}

- (ReferenceViewController *)negativeReferenceViewController
{
    if (!_negativeReferenceViewController)
    {
        _negativeReferenceViewController = [ReferenceViewController viewController];
        _negativeReferenceViewController.referenceType = ReferenceTypeNegative;
        _negativeReferenceViewController.user = self.user;
        _negativeReferenceViewController.view.frame = CGRectMake(self.view.frame.size.width, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    }
    
    return _negativeReferenceViewController;
}

@end
