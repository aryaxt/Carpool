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
}

#pragma - IBActions -

- (IBAction)cancelSelected:(id)sender
{
    [self.delegate locationSearchViewControllerDidSelectCance];
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
    SPGooglePlacesAutocompleteQuery *query = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyC52xwGjuNVfBq4yHlQiGrlswCERkZZ16w"];
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

@end
