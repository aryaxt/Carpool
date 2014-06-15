//
//  ReferenceViewController.h
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"

@protocol ReferenceViewControllerDelegate <NSObject>
- (void)referenceViewControllerDidSelectUserProfile:(User *)user;
@end

@interface ReferenceViewController : BaseViewController

@property (nonatomic, weak) id <ReferenceViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *referenceType;
@property (nonatomic, strong) User *user;

@end
