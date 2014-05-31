//
//  AutoResizingTextView.m
//  CarPool
//
//  Created by Aryan on 5/31/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "AutoResizingTextView.h"
#import "UIView+Additions.h"

@interface AutoResizingTextView()
@property (nonatomic, assign) CGRect rectBeforeAnimation;
@end

@implementation AutoResizingTextView

#define BUTTON_SIZE 30
#define BOTTOM_MARGIN 10
#define NAVBAR_AND_STATUSBAR_HEIGHT 64

#pragma mark - Initialization -

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initialize];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.layer.borderWidth = .6;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius = 5;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self performShowAnimation:YES withKeyboardNotification:note.userInfo];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self performShowAnimation:NO withKeyboardNotification:note.userInfo];
                                                  }];
}

#pragma mark - Private Methods -

- (void)performShowAnimation:(BOOL)show withKeyboardNotification:(NSDictionary *)note
{
    NSValue *boundValue = [note objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyBoardBound = [boundValue CGRectValue];
    CGRect rect = self.frame;
    
    if (show)
    {
        self.rectBeforeAnimation = rect;
        rect.origin.y = BUTTON_SIZE + NAVBAR_AND_STATUSBAR_HEIGHT;
        rect.size.height = self.superview.frame.size.height - keyBoardBound.size.height - BUTTON_SIZE - NAVBAR_AND_STATUSBAR_HEIGHT - BOTTOM_MARGIN;
    }
    else
    {
        rect = self.rectBeforeAnimation;
    }
    
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = rect;
                     } completion:^(BOOL finished) {
                         if (show)
                         {
                             UIButton *button = [self closeButton];
                             [self.superview addSubview:button];
                             [button animatePopWithCompletion:nil];
                         }
                     }];
    
}

- (UIButton *)closeButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(self.frame.size.width + self.frame.origin.x - BUTTON_SIZE,
                                self.frame.origin.y - BUTTON_SIZE, BUTTON_SIZE, BUTTON_SIZE)];
    [button addTarget:self action:@selector(closeSelected:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - IBAction -

- (void)closeSelected:(UIButton *)sender
{
    [sender animateShrinkWithCompletion:^{
        [sender removeFromSuperview];
        [self resignFirstResponder];
    }];
}

#pragma mark - IBAction -

- (IBAction)closeButtonSelected:(id)sender
{
    
}

@end
