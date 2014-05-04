//
//  CreateOfferViewController.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOfferViewController : UIViewController

@property (nonatomic, strong) IBOutlet UISegmentedControl *periodSegmentedControl;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UITextField *dateTextField;

- (IBAction)createSelected:(id)sender;
- (IBAction)cancelSelected:(id)sender;
- (IBAction)segmentedControlChanged:(id)sender;

@end
