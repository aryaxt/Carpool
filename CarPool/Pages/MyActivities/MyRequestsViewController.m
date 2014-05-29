//
//  MyRequestsViewController.m
//  CarPool
//
//  Created by Aryan on 5/28/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MyRequestsViewController.h"

@implementation MyRequestsViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showLoader];
    [self fetchAndPopulateMyRequests];
    
    __weak MyRequestsViewController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchAndPopulateMyRequests];
    }];
}

#pragma mark - Private MEthods -

- (void)fetchAndPopulateMyRequests
{
    [self.requestclient fetchMyRequestsIncludeOffer:NO
                                        includeFrom:NO
                                          includeTo:YES
                                     withCompletion:^(NSArray *requests, NSError *error) {
                                         [self hideLoader];
                                         [self.tableView.pullToRefreshView stopAnimating];
                                         
                                         if (error)
                                         {
                                             [self alertWithtitle:@"Error" andMessage:@"Error getting offers"];
                                         }
                                         else
                                         {
                                             self.requests = [requests mutableCopy];
                                             [self.tableView deleteRowsAndAnimateNewRowsInSectionZero:requests.count];
                                         }
                                     }];
}


#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.requests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *requestCellIdentifier = @"MyRequestCell";
    MyRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:requestCellIdentifier];
    
    CarPoolRequest *request = [self.requests objectAtIndex:indexPath.row];
    [cell setRequest:request];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarPoolRequest *request = [self.requests objectAtIndex:indexPath.row];
    RequestDetailViewController *vc = [RequestDetailViewController viewController];
    vc.request = request;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - Setter & Getter -

- (CarPoolRequestClient *)requestclient
{
    if (!_requestclient)
    {
        _requestclient = [[CarPoolRequestClient alloc] init];
    }
    
    return _requestclient;
}

@end
