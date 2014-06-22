//
//  NSArray+Additions.h
//  CarPool
//
//  Created by Aryan on 6/22/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

- (NSArray *)where:(BOOL (^)(id obj))query;

@end
