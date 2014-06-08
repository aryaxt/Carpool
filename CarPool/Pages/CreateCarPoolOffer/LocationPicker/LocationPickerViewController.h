//
//  LocationPickerViewController.h
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "StepsViewController.h"
#import "Location.h"

@protocol LocationPickerViewControllerDelegate <NSObject>
- (void)locationPickerViewControllerDidSelectStartLocation:(Location *)location;
- (void)locationPickerViewControllerDidSelectEndLocation:(Location *)location;
@end

@protocol LocationPickerViewControllerDataSource <NSObject>
- (UIViewController *)modalPresenterForLocationPickerViewController;
@end

@interface LocationPickerViewController : BaseViewController <StepViewController>

@property (nonatomic, weak) id <LocationPickerViewControllerDelegate> delegate;
@property (nonatomic, weak) id <LocationPickerViewControllerDataSource> dataSource;

@end
