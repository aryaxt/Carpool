//
//  Profile.h
//  CarPool
//
//  Created by Aryan on 5/18/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Profile : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *aboutMe;
@property (nonatomic, strong) NSString *interests;
@property (nonatomic, strong) NSString *media;

@end
