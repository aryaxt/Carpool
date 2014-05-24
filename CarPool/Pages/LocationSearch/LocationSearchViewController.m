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
    
    self.locationSearchHeaderView.layer.borderWidth = .6;
    self.locationSearchHeaderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mapView.delegate = self;
    
    [self switchToSearchType:SearchTypeText animated:NO];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(cancelSelected:)];
    self.navigationItem.leftBarButtonItem = cancelItem;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - PinEnabledMapViewDelegate -

- (void)pinEnabledMapViewWillStartSearchingInCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.indicatorView startAnimating];
}

- (void)pinEnabledMapViewDidFailToSearchWithError:(NSError *)error
{
    [self.indicatorView stopAnimating];
}

- (void)pinEnabledMapViewDidFindLocations:(NSArray *)locations
{
    [self.indicatorView stopAnimating];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Select Location" style:UIBarButtonItemStyleDone target:self action:@selector(mapLocationselected:)];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - IBActions -

- (void)mapLocationselected:(id)sender
{
    NSInteger index = [self.mapView.annotations indexOfObject:[self.mapView.selectedAnnotations firstObject]];
    Location *location = [self.mapView locationAtIndex:index];
    [self.delegate locationSearchViewControllerDidSelectLocation:location withTag:self.tag];
}

- (IBAction)cancelSelected:(id)sender
{
    [self.delegate locationSearchViewControllerDidSelectCance];
}

- (IBAction)searchTypeSelected:(id)sender
{
    SearchType switchToType = (self.tableView.frame.origin.x == 0) ? SearchTypeMap : SearchTypeText;
    [self switchToSearchType:switchToType animated:YES];
}

- (IBAction)currentLocationSelected:(id)sender
{
    LocationManager *locationManager = [LocationManager sharedInstance];
    SearchType type = (self.tableView.frame.origin.x == 0) ? SearchTypeText : SearchTypeMap;
    
    if (type == SearchTypeText)
    {
        if (locationManager.authorizationStatus != kCLAuthorizationStatusAuthorized)
        {
            [self alertWithtitle:@"Error" andMessage:@"Location manager is disabled, please enable location manager and try again"];
            return;
        }
        
        [self.indicatorView startAnimating];
        
        [self.locationSearchClient searchByLocation:locationManager.currentLocation
                                     withCompletion:^(NSArray *locations, NSError *error) {
                                         
                                         [self.indicatorView stopAnimating];
                                         
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
    else if (type == SearchTypeMap)
    {
        MKCoordinateRegion region = MKCoordinateRegionMake(
                                                           locationManager.currentLocation.coordinate,
                                                           MKCoordinateSpanMake(0, 0));
        [self.mapView setRegion:region animated:YES];
    }
}

#pragma mark - LocationSearchHeaderViewDelegate -

- (void)switchToSearchType:(SearchType)type animated:(BOOL)animated
{
    if (type == SearchTypeMap)
    {
        [self.mapView deselectAnnotation:[[self.mapView selectedAnnotations] firstObject] animated:YES];
        [self.searchBar resignFirstResponder];
        self.navigationItem.titleView = nil;
    }
    else
    {
        [self.searchBar becomeFirstResponder];
        self.navigationItem.rightBarButtonItem = nil;
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

#pragma mark - UISearchBarDelegate -

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length)
    {
        if (searchText.length > MIN_CHARACTER_REQUIRED_FOR_SEARCH)
        {
            [self.indicatorView startAnimating];
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
        
                                       [self.indicatorView stopAnimating];
                                       
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

- (LocationSearchClient *)locationSearchClient
{
    if (!_locationSearchClient)
    {
        _locationSearchClient = [[LocationSearchClient alloc] init];
    }
    
    return _locationSearchClient;
}

@end
