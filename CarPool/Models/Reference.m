//
//  Reference.m
//  CarPool
//
//  Created by Aryan on 5/18/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "Reference.h"
#import <Parse/PFObject+Subclass.h>

@implementation Reference
@dynamic text;
@dynamic type;
@dynamic from;
@dynamic to;

NSString *ReferenceTypePositive = @"positive";
NSString *ReferenceTypeNegative = @"negative";

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

+ (void)load
{
    [self registerSubclass];
}

@end
