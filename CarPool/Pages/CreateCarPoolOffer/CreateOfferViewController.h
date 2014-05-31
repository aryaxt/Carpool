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
#import "LocationSearchViewController.h"
#import "Location.h"
#import "CarPoolOfferClient.h"

@protocol CreateOfferViewControllerDelegate
- (void)createOfferViewControllerDidCreateOffer:(CarPoolOffer *)offer;
@end

@interface CreateOfferViewController : BaseViewController <LocationSearchViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, assign) id <CreateOfferViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UISegmentedControl *periodSegmentedControl;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UITextField *txtDate;
@property (nonatomic, strong) IBOutlet UITextField *txtStartLocation;
@property (nonatomic, strong) IBOutlet UITextField *txtEndLocation;
@property (nonatomic, strong) IBOutlet UITextView *txtMessage;
@property (nonatomic, strong) CarPoolOffer *offer;
@property (nonatomic, strong) CarPoolOfferClient *offerClient;

- (IBAction)createSelected:(id)sender;
- (IBAction)segmentedControlChanged:(id)sender;
- (IBAction)datePickerChangedValue:(id)sender;

@end
