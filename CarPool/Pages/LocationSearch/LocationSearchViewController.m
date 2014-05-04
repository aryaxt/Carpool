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
    
    SPGooglePlacesAutocompletePlace *place = [self.locations objectAtIndex:indexPath.row];
    cell.textLabel.text = place.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPGooglePlacesAutocompletePlace *place = [self.locations objectAtIndex:indexPath.row];
    [self.delegate locationSearchViewControllerDidSelectPlace:place];
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
    
    //TODO: Check to make sure that location exists, and user has given permission to CLLocationManager
    
    SPGooglePlacesAutocompleteQuery *query = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:AUTOCOMPLETE_API_KEY];
    query.language = @"en";
    query.location = CLLocationCoordinate2DMake(
                                                locationManager.currentLocation.coordinate.latitude,
                                                locationManager.currentLocation.coordinate.longitude);
    
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"There was a problem searching your location"];
        }
        else
        {
            if (places.count == 1)
            {
                [self.delegate locationSearchViewControllerDidSelectPlace:[places firstObject]];
            }
            else
            {
                [self alertWithtitle:@"Error" andMessage:@"There was a problem searching your location"];
            }
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
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(performSearch:) withObject:searchText afterDelay:.6];
        }
    }
    else
    {
        [self.tableView deleteRowsAndAnimateNewRowsIn:0];
    }
}

- (void)performSearch:(NSString *)search
{
    SPGooglePlacesAutocompleteQuery *query = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:AUTOCOMPLETE_API_KEY];
    query.input = search;
    //query.radius = 100.0;
    query.language = @"en";
    query.types = SPPlaceTypeGeocode; // Only return geocoding (address) results.
    //query.location = CLLocationCoordinate2DMake(37.76999, -122.44696);
    
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        self.locations = places;
        [self.tableView deleteRowsAndAnimateNewRowsIn:places.count];
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
