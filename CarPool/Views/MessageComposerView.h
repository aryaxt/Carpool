//
//  MessageComposerView.h
//  CarPool
//
//  Created by Aryan on 5/25/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageComposerViewDelegate <NSObject>
- (void)messageComposerViewDidSelectSendWithMessage:(NSString *)message;

@optional
- (void)messageComposerViewDidBecomeFirstResponser;
- (void)messageComposerViewDidResignFirstResponder;
- (void)messageComposerViewDidChangeSize;
@end

@interface MessageComposerView : UIView

@property (nonatomic, weak) id <MessageComposerViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextView *txtMessage;
@property (nonatomic, strong) IBOutlet UIButton *btnSend;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loader;

- (IBAction)sendSelected:(id)sender;
- (void)becomeFirstResponse;
- (void)resignFirstResponder;
- (BOOL)isFirstResponder;
- (void)reset;
- (void)resizeView;
- (void)setLoading:(BOOL)loading;

@end
