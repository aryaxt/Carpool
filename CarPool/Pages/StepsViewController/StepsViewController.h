//
//  StepsViewController.h
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"

@protocol StepViewController <NSObject>
- (BOOL)isStepValid;
- (NSString *)validationError;

@optional
- (void)stepWillAppear;
- (void)stepWillDisappear;
@end

@interface StepsViewController : BaseViewController

- (void)setStepViewControllers:(NSArray *)stepViewController;
- (void)moveToPreviousStep;
- (void)moveToNextStep;
- (BOOL)areStepsValid;

@end
