//
//  LocationSearchViewController.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UITableView+Additions.h"
#import "BaseViewController.h"
#import "LocationManager.h"
#import "LocationSearchClient.h"
#import "PinEnabledMapView.h"
#import "Location.h"

@protocol LocationSearchViewControllerDelegate <NSObject>
- (void)locationSearchViewControllerDidSelectCance;
- (void)locationSearchViewControllerDidSelectLocation:(Location *)location withTag:(NSString *)tag;
@end

@interface LocationSearchViewController : BaseViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, PinEnabledMapViewDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet PinEnabledMapView *mapView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) IBOutlet UIView *locationSearchHeaderView;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, weak) id <LocationSearchViewControllerDelegate> delegate;
@property (nonatomic, strong) LocationSearchClient *locationSearchClient;

- (IBAction)cancelSelected:(id)sender;
- (IBAction)currentLocationSelected:(id)sender;

@end
