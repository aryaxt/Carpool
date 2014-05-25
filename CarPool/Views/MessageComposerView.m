//
//  MessageComposerView.m
//  CarPool
//
//  Created by Aryan on 5/25/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MessageComposerView.h"

@interface MessageComposerView() <UITextViewDelegate>

@end

@implementation MessageComposerView

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MessageComposerView" owner:nil options:nil] firstObject];
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = .6;
    
    self.txtMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txtMessage.layer.borderWidth = .6;
    self.txtMessage.layer.cornerRadius = 5;
    self.txtMessage.text = @"";
    
    [self setLoading:NO];
    
    return self;
}

#pragma mark - Public Methods -

- (void)reset
{
    self.txtMessage.text = @"";
    [self sizeToFit];
}

- (void)becomeFirstResponse
{
    [self.txtMessage becomeFirstResponder];
}

- (void)resignFirstResponder
{
    [self.txtMessage resignFirstResponder];
}

- (BOOL)isFirstResponder
{
    return [self.txtMessage isFirstResponder];
}

- (void)setLoading:(BOOL)loading
{
    self.btnSend.hidden = (loading) ? YES : NO;
    self.loader.hidden = (loading) ? NO : YES;
}

#pragma mark - private -

- (void)resizeView
{
    CGRect rect = self.frame;
    CGFloat originalHeight = rect.size.height;
    rect.size.height = self.txtMessage.frame.origin.y + self.txtMessage.contentSize.height + 5;
    self.frame = rect;
    
    if (originalHeight != rect.size.height)
        [self.delegate messageComposerViewDidChangeSize];
}

#pragma mark - UITextViewDelegate -

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.delegate messageComposerViewDidBecomeFirstResponser];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.delegate messageComposerViewDidResignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self resizeView];
}

#pragma mark - IBActions -

- (IBAction)sendSelected:(id)sender
{
    [self.delegate messageComposerViewDidSelectSendWithMessage:self.txtMessage.text];
}

@end
