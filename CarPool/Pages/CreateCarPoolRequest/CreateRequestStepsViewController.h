//
//  CreateRequestStepsViewController.h
//  CarPool
//
//  Created by Aryan on 6/13/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "StepsViewController.h"
#import "CarPoolRequest.h"
#import "CarPoolOffer.h"

@protocol CreateRequestStepsViewControllerDelegate <NSObject>
- (void)createRequestStepsViewControllerDidCreateRequest:(CarPoolRequest *)request;
- (void)createRequestStepsViewControllerDidSelectCancel;
@end

@interface CreateRequestStepsViewController : StepsViewController

@property (nonatomic, weak) id <CreateRequestStepsViewControllerDelegate> delegate;
@property (nonatomic, strong) CarPoolOffer *offer;

@end
