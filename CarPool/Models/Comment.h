//
//  Comment.h
//  CarPool
//
//  Created by Aryan on 5/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"
#import "CarPoolRequest.h"

@interface Comment : PFObject<PFSubclassing>

extern NSString *CommentActionAccept;
extern NSString *CommentActionReject;
extern NSString *CommentActionMessage;

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSNumber *read;
@property (nonatomic, strong) CarPoolRequest *request;
@property (nonatomic, strong) User *from;
@property (nonatomic, strong) User *to;

@end
