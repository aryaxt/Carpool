//
//  MyOffersViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MyActivitiesViewController.h"

@implementation MyActivitiesViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    // since referenceView could have a negative x, it shows up when back clicked
    self.view.clipsToBounds = YES;
    
    [self.view addSubview:self.myOffersViewController.view];
    [self.view addSubview:self.myRequestsViewController.view];
    
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"CreateOfferViewController"])
    {
        CreateOfferViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}
#pragma mark - IBActions -

- (IBAction)segmentedControlDidChange:(id)sender
{
    CGRect myOffersRect = self.myOffersViewController.view.frame;
    CGRect myRequestsRect = self.myRequestsViewController.view.frame;
    
    myOffersRect.origin.x = (self.segmentedControl.selectedSegmentIndex == 0) ? 0 : self.view.frame.size.width*-1;
    myRequestsRect.origin.x = (self.segmentedControl.selectedSegmentIndex == 1) ? 0 : self.view.frame.size.width;
    
    [UIView animateWithDuration:.25
                          delay:
     0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.myOffersViewController.view.frame = myOffersRect;
                         self.myRequestsViewController.view.frame = myRequestsRect;
                     } completion:nil];
}

#pragma mark - CreateOfferViewControllerDelegate -

- (void)createOfferViewControllerDidCreateOffer:(CarPoolOffer *)offer
{
    [self.myOffersViewController addNewOffer:offer];
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - Setter & Getter -

- (MyOffersViewContorller *)myOffersViewController
{
    if (!_myOffersViewController)
    {
        _myOffersViewController = [MyOffersViewContorller viewController];
        _myOffersViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    }
                                   
    return _myOffersViewController;
}

- (MyRequestsViewController *)myRequestsViewController
{
    if (!_myRequestsViewController)
    {
        _myRequestsViewController = [MyRequestsViewController viewController];
        _myRequestsViewController.view.frame = CGRectMake(self.view.frame.size.width, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    }
    
    return _myRequestsViewController;
}

@end
