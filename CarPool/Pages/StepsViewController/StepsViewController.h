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

@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIButton *btnNext;
@property (nonatomic, strong) IBOutlet UIButton *btnPrevious;

- (void)setStepViewControllers:(NSArray *)stepViewController;
- (IBAction)nextSelected:(id)sender;
- (IBAction)previousSelected:(id)sender;
- (void)moveToPreviousStep;
- (void)moveToNextStep;

@end
