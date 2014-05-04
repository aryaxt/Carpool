//
//  CreateOfferViewController.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CarPoolOffer.h"

@protocol CreateOfferViewControllerDelegate
- (void)createOfferViewControllerDidSelectCancel;
- (void)createOfferViewControllerDidCreateOffer:(CarPoolOffer *)offer;
@end

@interface CreateOfferViewController : BaseViewController

@property (nonatomic, assign) id <CreateOfferViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UISegmentedControl *periodSegmentedControl;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UITextField *dateTextField;

- (IBAction)createSelected:(id)sender;
- (IBAction)cancelSelected:(id)sender;
- (IBAction)segmentedControlChanged:(id)sender;

@end
