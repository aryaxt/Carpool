//
//  BaseViewController.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NoContentView.h"

#define NO_CONTENT_FADE_ANIMATION_DURATION .3

@interface BaseViewController()
@property (nonatomic, strong) MBProgressHUD *progressHud;
@end

@implementation BaseViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.noContentView = [[NoContentView alloc] init];
}

#pragma mark - Public Methods -

- (void)alertWithtitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showLoader
{
    [self.progressHud show:YES];
}

- (void)hideLoader
{
    [self.progressHud hide:YES];
}

- (void)showNoContent:(BOOL)show
{
    if (show)
        [self.view addSubview:self.noContentView];
    
    self.noContentView.frame = self.view.bounds;
    
    [UIView animateWithDuration:NO_CONTENT_FADE_ANIMATION_DURATION animations:^{
        self.noContentView.alpha = (show) ? 1 : 0;
    } completion:^(BOOL finished) {
        if (!show)
            [self.noContentView removeFromSuperview];
    }];
}

#pragma mark - Google Analytics Helper -

- (void)trackPage:(NSString *)page
{
    [[GoogleAnalyticsManager sharedInstance] trackPage:page];
}

- (void)trackEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label andValue:(NSNumber *)value
{
    [[GoogleAnalyticsManager sharedInstance] trackEventWithCategory:category action:action label:label andValue:value];
}

#pragma mark - Setter & Getter -

- (MBProgressHUD *)progressHud
{
    if (!_progressHud)
    {
        _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHud];
    }
    
    return _progressHud;
}

@end
