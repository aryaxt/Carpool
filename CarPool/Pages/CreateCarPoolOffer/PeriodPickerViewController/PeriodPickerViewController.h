//
//  PeriodPickerViewController.h
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "StepsViewController.h"

@protocol PeriodPickerViewControllerDelegate <NSObject>
- (void)periodPickerViewControllerDidSelectPeriod:(NSNumber *)period;
@end

@interface PeriodPickerViewController : BaseViewController <StepViewController>

@property (nonatomic, weak) id <PeriodPickerViewControllerDelegate> delegate;

@end
