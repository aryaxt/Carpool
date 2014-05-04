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

@protocol LocationSearchViewControllerDelegate <NSObject>
- (void)locationSearchViewControllerDidSelectCance;
- (void)locationSearchViewControllerDidSelectPlace:(SPGooglePlacesAutocompletePlace *)place;
@end

@interface LocationSearchViewController : UIViewController <UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, weak) id <LocationSearchViewControllerDelegate> delegate;

- (IBAction)cancelSelected:(id)sender;

@end
