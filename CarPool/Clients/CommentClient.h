//
//  CommentClient.h
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"
#import "User.h"
#import "CarPoolRequest.h"

@interface CommentClient : NSObject

- (void)fetchCommentsForRequest:(CarPoolRequest *)request withCompletion:(void (^)(NSArray *comments, NSError *error))completion;
- (void)fetchUnreadCommentCountWithCompletion:(void (^)(NSNumber *unreadCommentCount, NSError *error))completion;
- (void)fetchCommentById:(NSString *)commentId withCompletion:(void (^)(Comment *comment, NSError *error))completion;
- (void)addCommentWithMessage:(NSString *)message toRequest:(CarPoolRequest *)request withCompletion:(void (^)(Comment *comment, NSError *error))completion;
- (void)sendCommentWithMessage:(NSString *)message toUser:(User *)user withCompletion:(void (^)(Comment *comment, NSError *error))completion;
- (void)fetchPersonalCommentsWithUser:(User *)user withCompletion:(void (^)(NSArray *comments, NSError *error))completion;
- (void)markCommentAsRead:(Comment *)comment;
- (void)fetchInboxCommentsWithCompletion:(void (^)(NSArray *comments, NSError *error))completion;
- (void)fetchUnredCommentCountForConversationWithUser:(User *)user withCompletion:(void (^)(NSNumber *count, NSError *error))completion;
- (void)fetchUnredCommentCountForRequest:(CarPoolRequest *)request withCompletion:(void (^)(NSNumber *count, NSError *error))completion;

@end
