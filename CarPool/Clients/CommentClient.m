//
//  CommentClient.m
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CommentClient.h"

@implementation CommentClient

- (void)fetchPersonalCommentsWithUser:(User *)user withCompletion:(void (^)(NSArray *comments, NSError *error))completion
{
    PFQuery *myCommentsQuery = [Comment query];
    [myCommentsQuery whereKey:@"from" equalTo:[User currentUser]];
    [myCommentsQuery whereKey:@"to" equalTo:user];
    [myCommentsQuery whereKeyDoesNotExist:@"request"];
    
    PFQuery *otherUserCommentsQuery = [Comment query];
    [otherUserCommentsQuery whereKey:@"to" equalTo:[User currentUser]];
    [otherUserCommentsQuery whereKey:@"from" equalTo:user];
    [otherUserCommentsQuery whereKeyDoesNotExist:@"request"];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[myCommentsQuery, otherUserCommentsQuery]];
    [query orderByAscending:@"createdAt"];
    
    [self fetchCommentsFromQuery:query withCompletion:completion];
}

- (void)fetchCommentsForRequest:(CarPoolRequest *)request withCompletion:(void (^)(NSArray *comments, NSError *error))completion
{
    PFQuery *query = [Comment query];
    [query whereKey:@"request" equalTo:request];
    [query orderByAscending:@"createdAt"];
    
    [self fetchCommentsFromQuery:query withCompletion:completion];
}

- (void)fetchCommentById:(NSString *)commentId withCompletion:(void (^)(Comment *comment, NSError *error))completion
{
    PFQuery *query = [Comment query];
    [query includeKey:@"from"];
    
    [query getObjectInBackgroundWithId:commentId block:^(PFObject *object, NSError *error) {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            completion((Comment *)object, nil);
        }
    }];
}

- (void)fetchUnreadCommentCountWithCompletion:(void (^)(NSNumber *unreadCommentCount, NSError *error))completion
{
    PFQuery *query = [Comment query];
    [query whereKey:@"read" notEqualTo:@YES];
    [query whereKey:@"to" equalTo:[User currentUser]];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            completion(@(number), nil);
        }
    }];
}

- (void)fetchInboxCommentsWithCompletion:(void (^)(NSArray *comments, NSError *error))completion
{
    [PFCloud callFunctionInBackground:@"InboxComments"
                       withParameters:@{}
                                block:^(id object, NSError *error) {
                                    if (error)
                                    {
                                        completion(nil, error);
                                    }
                                    else
                                    {
                                        completion(object, nil);
                                    }
                                }];
}

- (void)addCommentWithMessage:(NSString *)message toRequest:(CarPoolRequest *)request withCompletion:(void (^)(Comment *comment, NSError *error))completion
{
    Comment *comment = [[Comment alloc] init];
    comment.message = message;
    comment.action = CommentActionMessage;
    comment.from = [User currentUser];
    comment.request = request;
    comment.to = ([[User currentUser].objectId isEqualToString:request.from.objectId])
        ? request.to
        : request.from;
    
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            [request.comments addObject:comment];
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error)
                {
                    [comment deleteEventually];
                    completion(nil, error);
                }
                else
                {
                    completion(comment, nil);
                }
            }];
        }
    }];
}

- (void)sendCommentWithMessage:(NSString *)message toUser:(User *)user withCompletion:(void (^)(Comment *comment, NSError *error))completion
{
    Comment *comment = [[Comment alloc] init];
    comment.message = message;
    comment.action = CommentActionMessage;
    comment.from = [User currentUser];
    comment.to = user;
    
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            completion(comment, nil);
        }
    }];
}

- (void)markCommentAsRead:(Comment *)comment
{
    BOOL isToMe = ([comment.to.objectId isEqual:[User currentUser].objectId]) ? YES : NO;
    
    if ((comment.read && comment.read.boolValue == YES) || !isToMe)
        return;
    
    comment.read = @YES;
    [comment saveEventually];
}

- (void)fetchUnredCommentCountForConversationWithUser:(User *)user withCompletion:(void (^)(NSNumber *count, NSError *error))completion
{
    PFQuery *query = [Comment query];
    [query whereKey:@"to" equalTo:[User currentUser]];
    [query whereKey:@"from" equalTo:user];
    [query whereKey:@"read" notEqualTo:@YES];
    [query whereKeyDoesNotExist:@"request"];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            completion(@(number) ,nil);
        }
    }];
}

- (void)fetchUnredCommentCountForRequest:(CarPoolRequest *)request withCompletion:(void (^)(NSNumber *count, NSError *error))completion
{
    PFQuery *query = [Comment query];
    [query whereKey:@"to" equalTo:[User currentUser]];
    [query whereKey:@"request" equalTo:request];
    [query whereKey:@"read" notEqualTo:@YES];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            completion(@(number) ,nil);
        }
    }];
}

#pragma mark - Private Methods -


- (void)fetchCommentsFromQuery:(PFQuery *)query withCompletion:(void (^)(NSArray *comments, NSError *error))completion
{
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *comments = [NSMutableArray array];
        
        for (PFObject *object in objects)
        {
            [comments addObject:(Comment *)object];
        }
        
        completion(comments, error);
    }];
}

@end
