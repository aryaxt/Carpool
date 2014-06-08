//
//  SearchFilterViewController.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchFilter.h"

@protocol SearchFilterViewControllerDelegate <NSObject>
- (void)searchFilterViewControllerDidApplyFilter:(SearchFilter *)filter;
@end

@interface SearchFilterViewController : BaseViewController

@property (nonatomic, weak) id <SearchFilterViewControllerDelegate> delegate;
@property (nonatomic, strong) SearchFilter *searchFilter;

@end
