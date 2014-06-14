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

@protocol CreateReferenceViewControllerDelegate <NSObject>
- (void)createReferenceViewControllerDidSubmitReference:(Reference *)reference;
- (void)createReferenceViewControllerDidCancel;
@end

@interface CreateReferenceViewController : BaseViewController

@property (nonatomic, weak) id <CreateReferenceViewControllerDelegate> delegate;
@property (nonatomic, strong) User *user;

@end
