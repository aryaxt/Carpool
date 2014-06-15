//
//  MyOffersViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MyActivitiesViewController.h"
#import "CreateOfferStepsViewController.h"
#import "SlideNavigationController.h"
#import "CreateRequestStepsViewController.h"
#import "MyOffersViewContorller.h"
#import "MyRequestsViewController.h"
#import "UIViewController+Additions.h"
#import "CreateOfferStepsViewController.h"
#import "RequestDetailViewController.h"

@interface MyActivitiesViewController() <SlideNavigationControllerDelegate, CreateOfferStepsViewControllerDelegate, CreateRequestStepsViewControllerDelegate, MyRequestsViewControllerDelegate, MyOffersViewContorllerDelegate>
@property (nonatomic, strong) IBOutlet UIBarButtonItem *btnAddOffer;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) MyOffersViewContorller *myOffersViewController;
@property (nonatomic, strong) MyRequestsViewController *myRequestsViewController;@end

@implementation MyActivitiesViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self trackPage:GoogleAnalyticsManagerPageMyActivities];
    
    // since referenceView could have a negative x, it shows up when back clicked
    self.view.clipsToBounds = YES;
    
    [self.view addSubview:self.myOffersViewController.view];
    [self.view addSubview:self.myRequestsViewController.view];
}

#pragma mark - IBActions -

- (IBAction)segmentedControlDidChange:(id)sender
{
    CGRect myOffersRect = self.myOffersViewController.view.frame;
    CGRect myRequestsRect = self.myRequestsViewController.view.frame;
    
    myOffersRect.origin.x = (self.segmentedControl.selectedSegmentIndex == 0) ? 0 : self.view.frame.size.width*-1;
    myRequestsRect.origin.x = (self.segmentedControl.selectedSegmentIndex == 1) ? 0 : self.view.frame.size.width;
    
    [UIView animateWithDuration:.2
                          delay:
     0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.myOffersViewController.view.frame = myOffersRect;
                         self.myRequestsViewController.view.frame = myRequestsRect;
                     } completion:nil];
}

- (IBAction)createSeelcted:(id)sender
{
    UIViewController *vc;
    
    if(self.segmentedControl.selectedSegmentIndex == 0)
    {
        vc = [CreateOfferStepsViewController viewController];
        [(CreateOfferStepsViewController *)vc setDelegate:self];
    }
    else
    {
        vc = [CreateRequestStepsViewController viewController];
        [(CreateRequestStepsViewController *)vc setDelegate:self];
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - CreateOfferStepsViewControllerDelegate -

- (void)createOfferStepsViewControllerDidCreateOffer:(CarPoolOffer *)offer
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.myOffersViewController addNewOffer:offer];
    }];
}

- (void)createRequestStepsViewControllerDidSelectCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CreateRequestStepsViewController -

- (void)createRequestStepsViewControllerDidCreateRequest:(CarPoolRequest *)request
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.myRequestsViewController addNewRequest:request];
    }];
}

- (void)createOfferStepsViewControllerDidSelectCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - MyRequestsViewControllerDelegate -

- (void)myRequestsViewControllerDidSelectRequest:(CarPoolRequest *)request
{
    RequestDetailViewController *vc = [RequestDetailViewController viewController];
    vc.request = request;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MyOffersViewContorllerDelegate -

- (void)MyOffersViewContorllerDidSelectOffer:(CarPoolOffer *)offer
{
    // Go to offer detail page (Page doesn't exist yet)
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
        _myRequestsViewController.delegate = self;
        _myRequestsViewController.view.frame = CGRectMake(self.view.frame.size.width, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    }
    
    return _myRequestsViewController;
}

@end
