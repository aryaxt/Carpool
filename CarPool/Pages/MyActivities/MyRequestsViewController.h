//
//  MyRequestsViewController.h
//  CarPool
//
//  Created by Aryan on 5/28/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseViewController.h"
#import "CarPoolRequest.h"

@protocol MyRequestsViewControllerDelegate <NSObject>
- (void)myRequestsViewControllerDidSelectRequest:(CarPoolRequest *)request;
@end

@interface MyRequestsViewController : BaseViewController

@property (nonatomic, weak) id <MyRequestsViewControllerDelegate> delegate;

- (void)addNewRequest:(CarPoolRequest *)request;

@end
