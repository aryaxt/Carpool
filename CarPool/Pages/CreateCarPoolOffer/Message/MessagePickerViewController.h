//
//  MessagePickerViewController.h
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "StepsViewController.h"

@protocol MessagePickerViewControllerDelegate <NSObject>
- (void)messagePickerViewControllerDidEnterMessage:(NSString *)message;
@end

@interface MessagePickerViewController : BaseViewController <StepViewController>

@property (nonatomic, weak) id <MessagePickerViewControllerDelegate> delegate;

@end
