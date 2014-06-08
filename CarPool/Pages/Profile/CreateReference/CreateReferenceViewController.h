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
- (void)CreateReferenceViewControllerDidSubmitReference:(Reference *)reference;
@end

@interface CreateReferenceViewController : BaseViewController

@property (nonatomic, weak) id <CreateReferenceViewControllerDelegate> delegate;
@property (nonatomic, strong) User *user;

@end
