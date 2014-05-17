//
//  CommentClient.h
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"
#import "CarPoolRequest.h"

@interface CommentClient : NSObject

- (void)fetchMyCommentsWithCompletion:(void (^)(NSArray *comments, NSError *error))completion;
- (void)fetchCommentsForRequest:(CarPoolRequest *)request withCompletion:(void (^)(NSArray *comments, NSError *error))completion;
- (void)addComment:(Comment *)comment toRequest:(CarPoolRequest *)request withCompletion:(void (^)(NSError *error))completion;

@end
