//
//  MyRequestsViewController.m
//  CarPool
//
//  Created by Aryan on 5/28/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MyRequestsViewController.h"
#import "CarPoolRequestClient.h"
#import "MyRequestCell.h"
#import "UITableView+Additions.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "RequestDetailViewController.h"
#import "UIViewController+Additions.h"

@interface MyRequestsViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *requests;
@property (nonatomic, strong) CarPoolRequestClient *requestclient;
@end

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

#pragma mark - Public Methods -

- (void)addNewRequest:(CarPoolRequest *)request
{
    [self.requests insertObject:request atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.requests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarPoolRequest *request = [self.requests objectAtIndex:indexPath.row];
    NSString *requestCellIdentifier = ([request isOpenRequest]) ? @"MyOpenRequestCell" : @"MyRequestCell";
    MyRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:requestCellIdentifier];
    
    [cell setRequest:request];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarPoolRequest *request = [self.requests objectAtIndex:indexPath.row];
    [self.delegate myRequestsViewControllerDidSelectRequest:request];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarPoolRequest *request = [self.requests objectAtIndex:indexPath.row];
    return [request isOpenRequest] ? 120 : 155;
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
