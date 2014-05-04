//
//  Period.m
//  CarPool
//
//  Created by Aryan on 5/3/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "Period.h"
#import <Parse/PFObject+Subclass.h>

@implementation Period
@dynamic code;
@dynamic name;

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

@end
