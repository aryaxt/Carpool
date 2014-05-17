//
//  LocationSearchViewController.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "LocationSearchViewController.h"
#import "UIView+Additions.h"

typedef enum {
    SearchTypeMap,
    SearchTypeText
}SearchType;

@implementation LocationSearchViewController

#define MIN_CHARACTER_REQUIRED_FOR_SEARCH 3

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self switchToSearchType:SearchTypeText animated:NO];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(cancelSelected:)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UIBarButtonItem *loadingItem = [[UIBarButtonItem alloc] initWithTitle:@"Change"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(searchTypeSelected:)];
    self.navigationItem.rightBarButtonItem = loadingItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LocationSearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Location *location = [self.locations objectAtIndex:indexPath.row];
    cell.textLabel.text = location.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location *location = [self.locations objectAtIndex:indexPath.row];
    [self.delegate locationSearchViewControllerDidSelectLocation:location withTag:self.tag];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.locationSearchHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.locationSearchHeaderView.frame.size.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - IBActions -

- (IBAction)cancelSelected:(id)sender
{
    [self.delegate locationSearchViewControllerDidSelectCance];
}

- (void)searchTypeSelected:(id)sender
{
    SearchType type = (self.mapView.frame.origin.x == 0) ? SearchTypeText : SearchTypeMap;
    [self switchToSearchType:type animated:YES];
}

#pragma mark - LocationSearchHeaderViewDelegate -

- (void)switchToSearchType:(SearchType)type animated:(BOOL)animated
{
    if (type == SearchTypeMap)
    {
        [self.searchBar resignFirstResponder];
        self.navigationItem.titleView = nil;
    }
    else
    {
        [self.searchBar becomeFirstResponder];
        self.navigationItem.titleView = self.searchBar;
    }
    
    NSInteger width = self.view.frame.size.width;
    CGRect tableRect = self.tableView.frame;
    tableRect.origin.x = (type == SearchTypeText) ? 0 : width *-1;
    CGRect mapRect = self.mapView.frame;
    mapRect.origin.x = (type == SearchTypeMap) ? 0 : width *2;
    
    [UIView animateWithDuration:(animated) ? .3 : 0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.tableView.frame = tableRect;
        self.mapView.frame = mapRect;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)locationSearchHeaderViewDidSelectCurrentLocationSearch
{
    LocationManager *locationManager = [LocationManager sharedInstance];
    
    if (locationManager.authorizationStatus != kCLAuthorizationStatusAuthorized)
    {
        [self alertWithtitle:@"Error" andMessage:@"Location manager is disabled, please enable location manager and try again"];
        return;
    }
    
    [self.locationSearchHeaderView setShowLoader:YES];
    
    [self.locationSearchClient searchByLocation:locationManager.currentLocation
                                 withCompletion:^(NSArray *locations, NSError *error) {
        
                                     [self.locationSearchHeaderView setShowLoader:NO];
                                     
                                     if (error)
                                     {
                                         [self alertWithtitle:@"Error" andMessage:@"There was a problem searching for this location"];
                                     }
                                     else
                                     {
                                         self.locations = locations;
                                         [self.tableView deleteRowsAndAnimateNewRowsInSectionZero:locations.count];
                                     }
    }];
}

#pragma mark - UISearchBarDelegate -

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length)
    {
        if (searchText.length > MIN_CHARACTER_REQUIRED_FOR_SEARCH)
        {
            [self.locationSearchHeaderView setShowLoader:YES];
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(performSearch:) withObject:searchText afterDelay:.6];
        }
    }
    else
    {
        self.locations = nil;
        [self.tableView deleteRowsAndAnimateNewRowsInSectionZero:0];
    }
}

#pragma mark - Private Methods -

- (void)performSearch:(NSString *)search
{
    [self.locationSearchClient searchByKeyword:search
                                   withCompletion:^(NSArray *locations, NSError *error) {
        
                                       [self.locationSearchHeaderView setShowLoader:NO];
                                       
                                       if (error)
                                       {
                                           [self alertWithtitle:@"Error"
                                                     andMessage:@"There was a problem searching for this location"];
                                       }
                                       else
                                       {
                                           self.locations = locations;
                                           [self.tableView deleteRowsAndAnimateNewRowsInSectionZero:locations.count];
                                       }
    }];
}

#pragma mark - Setter & Getter -

- (LocationSearchHeaderView *)locationSearchHeaderView
{
    if (!_locationSearchHeaderView)
    {
        _locationSearchHeaderView = [[LocationSearchHeaderView alloc] init];
        _locationSearchHeaderView.delegate = self;
    }
    
    return _locationSearchHeaderView;
}

- (LocationSearchClient *)locationSearchClient
{
    if (!_locationSearchClient)
    {
        _locationSearchClient = [[LocationSearchClient alloc] init];
    }
    
    return _locationSearchClient;
}

@end
