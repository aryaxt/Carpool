//
//  LocationSearchViewController.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "LocationSearchViewController.h"

@implementation LocationSearchViewController

#define MIN_CHARACTER_REQUIRED_FOR_SEARCH 3
#define AUTOCOMPLETE_API_KEY @"AIzaSyC52xwGjuNVfBq4yHlQiGrlswCERkZZ16w"

#pragma - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.searchBar;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelected:)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UIBarButtonItem *loadingItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    self.navigationItem.rightBarButtonItem = loadingItem;
    
    [self.searchBar becomeFirstResponder];
}

#pragma - UITableView Delegate & Datasource -

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
    return self.currentLocationHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.currentLocationHeaderView.frame.size.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma - IBActions -

- (IBAction)cancelSelected:(id)sender
{
    [self.delegate locationSearchViewControllerDidSelectCance];
}

#pragma - CurrentLocationHeaderViewDelegate -

- (void)currentLocationHeaderViewDidDetectTap
{
    LocationManager *locationManager = [LocationManager sharedInstance];
    
    if (locationManager.authorizationStatus != kCLAuthorizationStatusAuthorized)
    {
        [self alertWithtitle:@"Error" andMessage:@"Location manager is disabled, please enable location manager and try again"];
        return;
    }
    
    [self.activityIndicatorView startAnimating];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationManager.currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       [self.activityIndicatorView stopAnimating];
                       
                       if (error)
                       {
                           [self alertWithtitle:@"Error" andMessage:@"There was a problem searching for this location"];
                       }
                       else
                       {
                           NSMutableArray *locations = [NSMutableArray array];
                           
                           for (CLPlacemark *placeMark in placemarks)
                           {
                               [locations addObject:[Location locationFromPlaceMark:placeMark]];
                           }
                           
                           self.locations = locations;
                           [self.tableView deleteRowsAndAnimateNewRowsIn:locations.count];
                       }
    }];
}

#pragma - UISearchBarDelegate -

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length)
    {
        if (searchText.length > MIN_CHARACTER_REQUIRED_FOR_SEARCH)
        {
            [self.activityIndicatorView startAnimating];
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(performSearch:) withObject:searchText afterDelay:.6];
        }
    }
    else
    {
        self.locations = nil;
        [self.tableView deleteRowsAndAnimateNewRowsIn:0];
    }
}

- (void)performSearch:(NSString *)search
{
    SPGooglePlacesAutocompleteQuery *query = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:AUTOCOMPLETE_API_KEY];
    query.input = search;
    query.language = @"en";
    query.types = SPPlaceTypeGeocode;
    
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        [self.activityIndicatorView stopAnimating];
        
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"There was a problem searching for this location"];
        }
        else
        {
            NSMutableArray *locations = [NSMutableArray array];
            
            for (SPGooglePlacesAutocompletePlace *place in places)
            {
                [locations addObject:[Location locationFromGoogleAutoCompletePLace:place]];
            }
            
            self.locations = locations;
            [self.tableView deleteRowsAndAnimateNewRowsIn:places.count];
        }
    }];
}

#pragma - Setter & Getter -

- (CurrentLocationHeaderView *)currentLocationHeaderView
{
    if (!_currentLocationHeaderView)
    {
        _currentLocationHeaderView = [[CurrentLocationHeaderView alloc] init];
        _currentLocationHeaderView.delegate = self;
    }
    
    return _currentLocationHeaderView;
}

@end
