//
//  ReferencesViewController.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "ReferenceViewController.h"
#import "User.h"

@interface ReferencesViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) ReferenceViewController *positiveReferenceViewController;
@property (nonatomic, strong) ReferenceViewController *negativeReferenceViewController;

- (IBAction)segmentedControlDidChange:(id)sender;

@end
