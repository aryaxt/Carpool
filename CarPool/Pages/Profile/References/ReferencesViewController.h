//
//  ReferencesViewController.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"

@interface ReferencesViewController : BaseViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSNumber *positiveReferenceCount;
@property (nonatomic, strong) NSNumber *negativeReferenceCount;

@end
