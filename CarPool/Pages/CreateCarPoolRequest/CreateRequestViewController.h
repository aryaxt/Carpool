//
//  CreateCarPoolRequestViewController.h
//  CarPool
//
//  Created by Aryan on 5/10/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CarPoolRequest.h"
#import "CarPoolOffer.h"
#import "CarPoolRequestClient.h"
#import "LocationSearchViewController.h"
#import "Comment.h"

@protocol CreateRequestViewControllerDelegate <NSObject>
- (void)createRequestViewControllerDidCreateRequest:(CarPoolRequest *)request;
@end

@interface CreateRequestViewController : BaseViewController <LocationSearchViewControllerDelegate>

@property (nonatomic, weak) id <CreateRequestViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextView *txtMessage;
@property (nonatomic, strong) IBOutlet UITextField *txtFrom;
@property (nonatomic, strong) IBOutlet UITextField *txtTo;
@property (nonatomic, strong) CarPoolOffer *offer;
@property (nonatomic, strong) CarPoolRequest *request;
@property (nonatomic, strong) CarPoolRequestClient *requestCleint;

- (IBAction)sendSelected:(id)sender;

@end
