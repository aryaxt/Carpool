//
//  OffersViewContorller.m
//  CarPool
//
//  Created by Aryan on 5/28/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MyOffersViewContorller.h"

@implementation MyOffersViewContorller

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showLoader];
    [self fetchAndPopulateMyOffers];
    
    __weak MyOffersViewContorller *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchAndPopulateMyOffers];
    }];
}

#pragma mark - Private Methods -

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
                                         [self.tableView deleteRowsAndAnimateNewRowsInSectionZero:offers.count];
                                     }
                                 }];
}

#pragma mark - Public Methods -

- (void)addNewOffer:(CarPoolOffer *)offer
{
    [self.offers insertObject:offer atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.offers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OfferCellIdentifier = @"MyOfferCell";
    MyOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:OfferCellIdentifier];
    
    CarPoolOffer *offer = [self.offers objectAtIndex:indexPath.row];
    [cell setOffer:offer];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
