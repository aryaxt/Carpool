//
//  Comment.m
//  CarPool
//
//  Created by Aryan on 5/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "Comment.h"
#import <Parse/PFObject+Subclass.h>

@implementation Comment
@dynamic message;
@dynamic action;
@dynamic read;
@dynamic from;
@dynamic to;
@dynamic request;

NSString *CommentActionAccepted = @"accepted";
NSString *CommentActionRejected = @"rejected";
NSString *CommentActionCanceled = @"canceled";
NSString *CommentActionMessage = @"message";

+ (NSString *)parseClassName
{
    return NSStringFromClass([self class]);
}

+ (void)load
{
    [self registerSubclass];
}

@end
