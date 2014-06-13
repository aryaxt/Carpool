//
//  DateTimePickerViewController.h
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "StepsViewController.h"

@protocol DateTimePickerViewControllerDelegate <NSObject>
- (void)dateTimePickerViewControllerDidSelectDate:(NSDate *)date;
@end

@protocol DateTimePickerViewControllerDataSource <NSObject>
- (UIDatePickerMode)datePickerModeForDateTimePickerViewController;
@end

@interface DateTimePickerViewController : BaseViewController <StepViewController>

@property (nonatomic, weak) id <DateTimePickerViewControllerDelegate> delegate;
@property (nonatomic, weak) id <DateTimePickerViewControllerDataSource> dataSource;

@end
