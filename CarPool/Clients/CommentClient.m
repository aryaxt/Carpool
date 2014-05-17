//
//  CommentClient.m
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CommentClient.h"

@implementation CommentClient

- (void)addComment:(Comment *)comment toRequest:(CarPoolRequest *)request withCompletion:(void (^)(NSError *error))completion
{
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            completion(error);
        }
        else
        {
            [request.comments addObject:comment];
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error)
                {
                    [comment deleteEventually];
                    completion(error);
                }
                else
                {
                    completion(nil);
                }
            }];
        }
    }];
}

- (void)fetchMyCommentsWithCompletion:(void (^)(NSArray *comments, NSError *error))completion
{
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Comment class])];
    [query whereKey:@"to" equalTo:[User currentUser]];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"from"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *comments = [NSMutableArray array];
        
        for (PFObject *object in objects)
        {
            [comments addObject:(Comment *)object];
        }
        
        completion(comments, error);
    }];
}

- (void)fetchCommentsForRequest:(CarPoolRequest *)request withCompletion:(void (^)(NSArray *comments, NSError *error))completion
{
    [request.comments.query orderByDescending:@"createdAt"];
    
    [request.comments.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *comments = [NSMutableArray array];
        
        for (PFObject *object in objects)
        {
            [comments addObject:(Comment *)object];
        }
        
        completion(comments, error);
    }];
}

@end
