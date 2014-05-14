//
//  MyOffersViewController.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MyOffersViewController.h"

@implementation MyOffersViewController

#define CELL_MIN_HEIGHT 117
#define CELL_MAX_HEIGHT 163

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.offers = [NSMutableArray array];
    
    [self showLoader];
    [self fetchAndPopulateData];
    
    __weak MyOffersViewController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchAndPopulateData];
    }];
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

- (void)fetchAndPopulateData
{
    [self.offerClient fetchCarpoolOffersForUser:[PFUser currentUser]
                               includeLocations:YES
                                    includeUser:NO
                                 withCompletion:^(NSArray *offers, NSError *error) {
                                     [self hideLoader];
                                     [self.tableView.pullToRefreshView stopAnimating];
                                     
                                     if (error)
                                     {
                                         // Show Error
                                     }
                                     else
                                     {
                                         self.offers = [offers mutableCopy];
                                         [self.tableView deleteRowsAndAnimateNewRowsIn:self.offers.count];
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

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.offers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyOfferCell";
    MyOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    CarPoolOffer *offer = [self.offers objectAtIndex:indexPath.row];
    [cell setOffer:offer];
    [cell setDelegate:self];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self.indexPathForExpandedCell isEqual:indexPath]) ? CELL_MAX_HEIGHT : CELL_MIN_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.indexPathForExpandedCell isEqual:indexPath])
    {
        self.indexPathForExpandedCell = nil;
    }
    else
    {
        self.indexPathForExpandedCell = indexPath;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - MyOfferCellDelegate MEthods -

- (void)myOfferCellDidSelectDelete:(MyOfferCell *)cell
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                    message:@"Are you sure you want to delete this offer?"
                                           cancelButtonItem:[RIButtonItem itemWithLabel:@"Yes"
                                                                                 action:^{
        
                                                                                     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
                                                                                     [self deleteOfferAtIndePath:indexPath];
                                                                                     
    }]
                                           otherButtonItems:[RIButtonItem itemWithLabel:@"No" action:nil], nil];
    
    [alert show];
}

- (void)myOfferCellDidSelectEdit:(MyOfferCell *)cell
{
    
}

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

@end
