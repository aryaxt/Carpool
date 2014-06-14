//
//  ProfileEditableCell.m
//  CarPool
//
//  Created by Aryan on 6/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ProfileEditableCell.h"

@interface ProfileEditableCell() <UITextViewDelegate>
@property (nonatomic, assign) BOOL isInEditMode;
@property (nonatomic, strong) IBOutlet UILabel *lblText;
@property (nonatomic, strong) IBOutlet UITextView *txtText;
@end

@implementation ProfileEditableCell

#define INOUT_OFFSET 10

#pragma mark - Initialization -

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    self.txtText.text = @"";
    self.lblText.text = @"";
    [self setIsInEditMode:NO];
    return self;
}

#pragma mark - UITextViewDelegate -

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect initialFrame = self.frame;
    [self resizeCell];
    CGRect finalFrame = self.frame;
    
    if (!CGRectEqualToRect(initialFrame, finalFrame))
        [self.delegate profileEditableCellDidChangeSize:self];
}

#pragma mark - Private Methods -

- (void)resizeCell
{
    UIView *inputView = (self.isInEditMode) ? self.txtText : self.lblText;
    inputView.frame = CGRectMake(INOUT_OFFSET, INOUT_OFFSET, self.frame.size.width-(2*INOUT_OFFSET), 0);
    [inputView sizeToFit];
    
    CGRect rect = self.frame;
    rect.size.height = inputView.frame.size.height + inputView.frame.origin.y + 10;
    self.frame = rect;
}

#pragma mark - Public Methods -

- (void)setIsInEditMode:(BOOL)editMode
{
    _isInEditMode = editMode;
    
    self.lblText.hidden = (editMode) ? YES : NO;
    self.txtText.hidden = (editMode) ? NO : YES;
    
    if (editMode)
    {
        self.txtText.text = self.lblText.text;
        [self.txtText becomeFirstResponder];
    }
    
    [self resizeCell];
}

- (void)setText:(NSString *)text
{
    self.lblText.text = text;
    [self resizeCell];
}

- (NSString *)editedText
{
    return self.txtText.text;
}

@end
