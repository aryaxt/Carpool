//
//  CreateCarPoolRequestViewController.h
//  CarPool
//
//  Created by Aryan on 5/10/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CarPoolRequest.h"
#import "CarPoolRequestEngine.h"
#import "CarPoolOffer.h"
#import "LocationSearchViewController.h"
#import "Comment.h"

@protocol CreateRequestViewControllerDelegate <NSObject>
- (void)createRequestViewControllerDidSelectCancel;
- (void)createRequestViewControllerDidCreateOffer:(CarPoolOffer *)offer;
@end

@interface CreateRequestViewController : BaseViewController <LocationSearchViewControllerDelegate>

@property (nonatomic, weak) id <CreateRequestViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextView *txtMessage;
@property (nonatomic, strong) IBOutlet UITextField *txtFrom;
@property (nonatomic, strong) IBOutlet UITextField *txtTo;
@property (nonatomic, strong) IBOutlet UIView *messageView;
@property (nonatomic, strong) IBOutlet UIButton *btnCloseMessage;
@property (nonatomic, strong) CarPoolOffer *offer;
@property (nonatomic, strong) CarPoolRequest *request;
@property (nonatomic, strong) CarPoolRequestEngine *requestEngine;
@property (nonatomic, assign) CGRect messageViewOriginalFrame;

- (IBAction)sendSelected:(id)sender;
- (IBAction)cancelSelected:(id)sender;
- (IBAction)closeMessageSelected:(id)sender;

@end
