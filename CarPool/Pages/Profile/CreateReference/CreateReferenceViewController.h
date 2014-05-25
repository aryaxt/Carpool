//
//  CreateReferenceViewController.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"
#import "Reference.h"
#import "ReferenceClient.h"

@protocol CreateReferenceViewControllerDelegate <NSObject>
- (void)CreateReferenceViewControllerDidSubmitReference:(Reference *)reference;
@end

@interface CreateReferenceViewController : BaseViewController

@property (nonatomic, weak) id <CreateReferenceViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextView *txtReference;
@property (nonatomic, strong) IBOutlet UISegmentedControl *referenceTypeSegmentedControl;
@property (nonatomic, strong) IBOutlet UIImageView *imgUserPhoto;
@property (nonatomic, strong) IBOutlet UILabel *lblUserName;
@property (nonatomic, strong) ReferenceClient *referenceClient;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Reference *reference;

- (IBAction)sendSelected:(id)sender;

@end
