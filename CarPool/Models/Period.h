//
//  Period.h
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Parse/Parse.h>

@interface Period : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;

@end
