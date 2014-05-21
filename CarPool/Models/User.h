//
//  User.h
//  CarPool
//
//  Created by Aryan on 5/9/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Profile.h"

@interface User : PFUser<PFSubclassing>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) Profile *profile;
@property (nonatomic, strong, readonly) PFRelation *friends;
@property (nonatomic, strong, readonly) PFRelation *blockedUsers;

@end
