//
//  StepsViewController.m
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "StepsViewController.h"

@interface StepsViewController()
@property (nonatomic, assign) NSInteger currentStep;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UILabel *lblError;
@end

@implementation StepsViewController

#define BOUNCE_OFFSET 20
#define BOUNCE_ANIMATION .1
#define STEP_CHANGE_ANIMATION .25

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentView.layer.borderWidth = .6;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.topView.layer.borderWidth = .6;
    self.topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - Public Methods -

- (void)setStepViewControllers:(NSArray *)stepViewController
{
    for (UIViewController *step in stepViewController)
    {
        if (![step conformsToProtocol:@protocol(StepViewController)])
        {
            @throw ([NSException exceptionWithName:@"InvalidArgumentException"
                                            reason:[NSString stringWithFormat:@"%@ does not conform to StepViewController protocol", NSStringFromClass([step class])]
                                          userInfo:nil]);
        }
        
        step.view.frame = self.contentView.bounds;
    }
    
    
    self.viewControllers = stepViewController;
    self.pageControl.numberOfPages = stepViewController.count;
    self.currentStep = -1;
    [self moveToStep:0 animated:NO];
}

- (void)moveToStep:(NSInteger)step animated:(BOOL)animated
{
    if (step == self.currentStep)
        return;
    
    UIViewController<StepViewController> *currentStepViewController = (self.currentStep == -1) ? nil :  [self.viewControllers objectAtIndex:self.currentStep];
    UIViewController<StepViewController> *newStepViewController = [self.viewControllers objectAtIndex:step];
    
    CGRect currentRect = currentStepViewController.view.frame;
    currentRect.origin.x = (step > self.currentStep) ? self.contentView.frame.size.width * -1 : self.contentView.frame.size.width;
    
    __block CGRect newRect = newStepViewController.view.frame;
    newRect.origin.x = (self.currentStep > step) ? self.contentView.frame.size.width * -1 : self.contentView.frame.size.width;
    newStepViewController.view.frame = newRect;
    [self.contentView addSubview:newStepViewController.view];
    newRect.origin.x = (step > self.currentStep) ? -1*BOUNCE_OFFSET : BOUNCE_OFFSET;
    
    self.currentStep = step;
    self.pageControl.currentPage = step;
    self.lblTitle.text = newStepViewController.title;
    self.btnPrevious.hidden = (step == 0) ? YES : NO;
    self.btnNext.hidden = (step < self.viewControllers.count-1) ? NO : YES;
    
    if ([currentStepViewController respondsToSelector:@selector(stepWillDisappear)])
        [currentStepViewController stepWillDisappear];
    
    if ([newStepViewController respondsToSelector:@selector(stepWillAppear)])
        [newStepViewController stepWillAppear];
    
    [UIView animateWithDuration:(animated) ? STEP_CHANGE_ANIMATION : 0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         currentStepViewController.view.frame = currentRect;
                         newStepViewController.view.frame = newRect;
    } completion:^(BOOL finished) {
        [currentStepViewController.view removeFromSuperview];
        
        [UIView animateWithDuration:(animated) ? BOUNCE_ANIMATION : 0
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             newRect.origin.x = 0;
                             newStepViewController.view.frame = newRect;
                         } completion:nil];
    }];
}

- (void)moveToPreviousStep
{
    if (self.currentStep > 0)
    {
        [self moveToStep:self.currentStep-1 animated:YES];
    }
}

- (void)moveToNextStep
{
    UIViewController<StepViewController> *currentStepViewController = [self.viewControllers objectAtIndex:self.currentStep];
    if (![currentStepViewController isStepValid])
    {
        [self showError:[currentStepViewController validationError]];
        return;
    }
    
    if (self.currentStep < self.viewControllers.count-1)
    {
        [self moveToStep:self.currentStep+1 animated:YES];
    }
}

- (void)showError:(NSString *)error
{
    if (!self.lblError)
    {
        self.lblError = [[UILabel alloc] initWithFrame:self.topView.bounds];
        self.lblError.textColor = [UIColor redColor];
        self.lblError.backgroundColor = [UIColor whiteColor];
        self.lblError.alpha = 0;
        self.lblError.font = [UIFont boldSystemFontOfSize:12];
        self.lblError.textAlignment = NSTextAlignmentCenter;
    }
    
    [self.topView addSubview:self.lblError];
    self.lblError.text = error;
    
    [UIView animateWithDuration:.25 animations:^{
        self.lblError.alpha = 1;
    } completion:^(BOOL finished) {
        
        int64_t delay = 3.0;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^(void){
            
            [UIView animateWithDuration:.25 animations:^{
                self.lblError.alpha = 0;
            } completion:^(BOOL finished) {
                [self.lblError removeFromSuperview];
            }];
        });
    }];
}

#pragma mark - IBactions -

- (IBAction)nextSelected:(id)sender
{
    [self moveToNextStep];
}

- (IBAction)previousSelected:(id)sender
{
    [self moveToPreviousStep];
}

@end
