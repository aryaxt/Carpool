//
//  SearchFilterViewController.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchFilter.h"
#import "LocationSearchViewController.h"

@protocol SearchFilterViewControllerDelegate <NSObject>
- (void)searchFilterViewControllerDidApplyFilter:(SearchFilter *)filter;
@end

@interface SearchFilterViewController : BaseViewController <LocationSearchViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <SearchFilterViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIPickerView *agePicker;
@property (nonatomic, strong) IBOutlet UITextField *txtFromLocation;
@property (nonatomic, strong) IBOutlet UITextField *txtToLocation;
@property (nonatomic, strong) IBOutlet UITextField *txtDate;
@property (nonatomic, strong) IBOutlet UITextField *txtAge;
@property (nonatomic, strong) NSArray *ageRanges;
@property (nonatomic, strong) SearchFilter *searchFilter;

- (IBAction)clearFilterSelected:(id)sender;
- (IBAction)applyFilterselected:(id)sender;
- (IBAction)genderSegmentedControlChanged:(id)sender;
- (IBAction)datePickerChangedValue:(id)sender;

@end
