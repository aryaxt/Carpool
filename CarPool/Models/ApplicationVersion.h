//
//  ApplicationVersion.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ApplicationVersion : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *lastRequiredVersion;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *message;

@end
