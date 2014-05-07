//
//  LocationSearchViewController.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "UITableView+Additions.h"
#import "CurrentLocationHeaderView.h"
#import "BaseViewController.h"
#import "LocationManager.h"
#import "Location.h"

@protocol LocationSearchViewControllerDelegate <NSObject>
- (void)locationSearchViewControllerDidSelectCance;
- (void)locationSearchViewControllerDidSelectLocation:(Location *)location withTag:(NSString *)tag;
@end

@interface LocationSearchViewController : BaseViewController <UISearchBarDelegate, CurrentLocationHeaderViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) CurrentLocationHeaderView *currentLocationHeaderView;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, weak) id <LocationSearchViewControllerDelegate> delegate;

- (IBAction)cancelSelected:(id)sender;

@end
