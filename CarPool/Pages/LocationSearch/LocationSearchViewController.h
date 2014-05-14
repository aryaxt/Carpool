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
#import "LocationSearchHeaderView.h"
#import "BaseViewController.h"
#import "LocationManager.h"
#import "LocationSearchClient.h"
#import "Location.h"

@protocol LocationSearchViewControllerDelegate <NSObject>
- (void)locationSearchViewControllerDidSelectCance;
- (void)locationSearchViewControllerDidSelectLocation:(Location *)location withTag:(NSString *)tag;
@end

@interface LocationSearchViewController : BaseViewController <UISearchBarDelegate, LocationSearchHeaderViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) LocationSearchHeaderView *locationSearchHeaderView;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, weak) id <LocationSearchViewControllerDelegate> delegate;
@property (nonatomic, strong) LocationSearchClient *locationSearchClient;

- (IBAction)cancelSelected:(id)sender;

@end
