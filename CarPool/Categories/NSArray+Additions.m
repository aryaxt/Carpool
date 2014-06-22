//
//  NSArray+Additions.m
//  CarPool
//
//  Created by Aryan on 6/22/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSArray *)where:(BOOL (^)(id obj))query
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (id object in self)
    {
        if (query(object))
            [result addObject:object];
    }
    
    return result;
}

@end
