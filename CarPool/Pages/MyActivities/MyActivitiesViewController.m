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
    [super viewDidLoad];
    
    self.offers = [NSMutableArray array];
    
    [self showLoader];
    [self fetchAndPopulateMyOffers];
    [self fetchAndPopulateMyRequests];
    
    __weak MyActivitiesViewController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        if (weakSelf.segmentedControl.selectedSegmentIndex == 0)
        {
            [weakSelf fetchAndPopulateMyOffers];
        }
        else
        {
            [weakSelf fetchAndPopulateMyRequests];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"CreateOfferViewController"])
    {
        CreateOfferViewController *vc = (CreateOfferViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
        vc.delegate = self;
    }
}

#pragma mark - Private Methods -

- (void)populateData
{
    int count = (self.segmentedControl.selectedSegmentIndex == 0) ? self.offers.count : self.requests.count;
    int insertAnimation = (self.segmentedControl.selectedSegmentIndex == 0) ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight;
    int deleteAnimation = (self.segmentedControl.selectedSegmentIndex == 0) ? UITableViewRowAnimationRight : UITableViewRowAnimationLeft;
    
    
    [self.tableView deleteRowsAndAnimateNewRows:count inSection:0 withDeleteAnimatiion:deleteAnimation andInsertAnimation:insertAnimation];
}

- (void)fetchAndPopulateMyRequests
{
    [self.requestclient fetchMyRequestsIncludeOffer:NO
                                        includeFrom:NO
                                          includeTo:YES
                                     withCompletion:^(NSArray *requests, NSError *error) {
                                         if (error)
                                         {
                                             [self alertWithtitle:@"Error" andMessage:@"Error getting offers"];
                                         }
                                         else
                                         {
                                             self.requests = [requests mutableCopy];
                                             
                                             if (self.segmentedControl.selectedSegmentIndex == 1)
                                                 [self populateData];
                                         }
    }];
}

- (void)fetchAndPopulateMyOffers
{
    [self.offerClient fetchCarpoolOffersForUser:[PFUser currentUser]
                               includeLocations:YES
                                    includeUser:NO
                                 withCompletion:^(NSArray *offers, NSError *error) {
                                     [self hideLoader];
                                     [self.tableView.pullToRefreshView stopAnimating];
                                     
                                     if (error)
                                     {
                                         [self alertWithtitle:@"Error" andMessage:@"Error getting offers"];
                                     }
                                     else
                                     {
                                         self.offers = [offers mutableCopy];
                                         
                                         if (self.segmentedControl.selectedSegmentIndex == 0)
                                             [self populateData];
                                     }
                                 }];
}

- (void)deleteOfferAtIndePath:(NSIndexPath *)indexPath
{
    CarPoolOffer *offer = [self.offers objectAtIndex:indexPath.row];
    
    [self showLoader];
    
    [self.offerClient deleteCarpoolOffer:offer
                          withCompletion:^(BOOL succeeded, NSError *error) {
                              
                              [self hideLoader];
                              
                              if (error)
                              {
                                  // Show error
                              }
                              else
                              {
                                  [self.offers removeObject:offer];
                                  [self.tableView deleteRowsAtIndexPaths:@[indexPath ]withRowAnimation:UITableViewRowAnimationLeft];
                              }
    }];
}

#pragma mark - IBActions -

- (IBAction)segmentedControlDidChange:(id)sender
{
    self.navigationItem.rightBarButtonItem = (self.segmentedControl.selectedSegmentIndex == 0)
        ? self.btnAddOffer
        : nil;
    
    [self populateData];
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        return self.offers.count;
    }
    else
    {
        return self.requests.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        static NSString *OfferCellIdentifier = @"MyOfferCell";
        MyOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:OfferCellIdentifier];
        
        CarPoolOffer *offer = [self.offers objectAtIndex:indexPath.row];
        [cell setOffer:offer];
        [cell setDelegate:self];
        return cell;
    }
    else
    {
        static NSString *requestCellIdentifier = @"MyRequestCell";
        MyRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:requestCellIdentifier];
        
        CarPoolRequest *request = [self.requests objectAtIndex:indexPath.row];
        [cell setRequest:request];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        return 120;
    }
    else
    {
        return 155;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {

    }
    else
    {
        CarPoolRequest *request = [self.requests objectAtIndex:indexPath.row];
        RequestDetailViewController *vc = [RequestDetailViewController viewController];
        vc.request = request;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - MyOfferCellDelegate MEthods -


#pragma mark - CreateOfferViewControllerDelegate -

- (void)createOfferViewControllerDidSelectCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createOfferViewControllerDidCreateOffer:(CarPoolOffer *)offer
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.offers insertObject:offer atIndex:0];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationTop];
    }];
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
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

- (CarPoolRequestClient *)requestclient
{
    if (!_requestclient)
    {
        _requestclient = [[CarPoolRequestClient alloc] init];
    }
    
    return _requestclient;
}

@end
