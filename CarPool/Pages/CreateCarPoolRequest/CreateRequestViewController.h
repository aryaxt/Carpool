//
//  CreateCarPoolRequestViewController.h
//  CarPool
//
//  Created by Aryan on 5/10/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CarPoolRequest.h"

@protocol CreateRequestViewControllerDelegate <NSObject>
- (void)createRequestViewControllerDidCreateRequest:(CarPoolRequest *)request;
@end

@interface CreateRequestViewController : BaseViewController

@property (nonatomic, weak) id <CreateRequestViewControllerDelegate> delegate;
@property (nonatomic, strong) CarPoolOffer *offer;

@end
