//
//  SearchFilterViewController.m
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "SearchFilterViewController.h"
#import "LocationSearchViewController.h"
#import "UIViewController+Additions.h"

@implementation SearchFilterViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topView.layer.borderWidth = .6;
    self.topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - IBAction -

- (IBAction)clearFilterSelected:(id)sender
{
    
}

- (IBAction)applyFilterselected:(id)sender
{
    [self.delegate searchFilterViewControllerDidApplyFilter:self.searchFilter];
}

- (IBAction)genderSegmentedControlChanged:(id)sender
{
    switch (self.genderSegmentedControl.selectedSegmentIndex)
    {
        case 0:
        self.searchFilter.gender = @1;
        break;
        
        case 1:
        self.searchFilter.gender = nil;
        break;
        
        case 2:
        self.searchFilter.gender = @2;
        break;
    }
}

@end
