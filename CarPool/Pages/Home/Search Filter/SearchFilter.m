//
//  SearchFilter.m
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "SearchFilter.h"

@implementation SearchFilter

- (id)init
{
    if (self = [super init])
    {
        self.minAge = @18;
        self.maxAge = @99;
        self.date = [NSDate date];
    }
    
    return self;
}

@end
