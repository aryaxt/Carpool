//
//  InboxViewController.m
//  CarPool
//
//  Created by Aryan on 5/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "InboxViewController.h"

@implementation InboxViewController

#define REQUEST_DETAIL_SEGUE_IDENTIFIER @"RequestDetailViewController"
#define PERSONAL_MESSAGES_SEGUE_IDENTIFIER @"PersonalMessagesViewController"

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberOfUnreadsRelatedToCommentGroup = [NSMutableDictionary dictionary];
    
    [self showLoader];
    [self fetchAndPopulateDataAnimated:YES withCompletion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    
    if ([segue.identifier isEqual:REQUEST_DETAIL_SEGUE_IDENTIFIER])
    {
        RequestDetailViewController *vc = segue.destinationViewController;
        vc.request = comment.request;
    }
    else if ([segue.identifier isEqual:PERSONAL_MESSAGES_SEGUE_IDENTIFIER])
    {
        PersonalMessagesViewController *vc = segue.destinationViewController;
        vc.user = comment.from;
    }
}

#pragma mark - SlideNavigationControllerDelegate -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - PushNotificationHandler -

- (BOOL)canHandlePushNotificationWithType:(NSString *)type andData:(NSDictionary *)data
{
    if ([type isEqualToString:PushNotificationTypeComment])
    {
        NSString *commentId = [data objectForKey:@"commentId"];
        
        [self.commentClient fetchCommentById:commentId
                              withCompletion:^(Comment *comment, NSError *error) {
                                  NSInteger indexOfRelevantComment = [self indexOfRelevantComment:comment];
                                  
                                  [self.tableView beginUpdates];
                                  if (indexOfRelevantComment == NSNotFound)
                                  {
                                      [self.comments insertObject:comment atIndex:0];
                                      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                      [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                  }
                                  else
                                  {
                                      [self.comments replaceObjectAtIndex:indexOfRelevantComment withObject:comment];
                                      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexOfRelevantComment inSection:0];
                                      [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                  }
                                  [self.tableView endUpdates];
        }];
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Private Methods -

- (NSInteger)indexOfRelevantComment:(Comment *)newComment
{
    NSString *otherUserId = ([[User currentUser].objectId isEqual:newComment.from.objectId])
        ? newComment.to.objectId
        : newComment.from.objectId;
    
    for (int i=0 ; i<self.comments.count ; i++)
    {
        Comment *comment = [self.comments objectAtIndex:i];
        
        if (comment.request)
        {
            if ([comment.request.objectId isEqual:newComment.request.objectId])
                return i;
        }
        else
        {
            if ([comment.from.objectId isEqual:otherUserId] ||
                [comment.to.objectId isEqual:otherUserId])
                return i;
        }
    }
    
    return NSNotFound;
}

- (void)fetchAndPopulateDataAnimated:(BOOL)animated withCompletion:(void (^)(void))completion
{
    [self.commentClient fetchInboxCommentsWithCompletion:^(NSArray *comments, NSError *error) {
        [self hideLoader];
        
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"There was a problem loading requests"];
        }
        else
        {
            [self filterAndAddComments:comments];
            
            if (animated)
                [self.tableView deleteRowsAndAnimateNewRowsInSectionZero:self.comments.count];
            else
                [self.tableView reloadData];
            
            if (completion)
                completion();
        }
    }];
}

- (void)filterAndAddComments:(NSArray *)comments
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (Comment *comment in comments)
    {
        if (comment.request)
        {
            Comment *existingcomment = [dictionary objectForKey:comment.request.objectId];
            
            if (existingcomment)
            {
                if ([comment.createdAt timeIntervalSinceDate:existingcomment.createdAt] > 0)
                {
                    [dictionary setObject:comment forKey:comment.request.objectId];
                }
            }
            else
            {
                [dictionary setObject:comment forKey:comment.request.objectId];
            }
        }
        else
        {
            Comment *existingcomment = [dictionary objectForKey:comment.from.objectId];
            
            if (existingcomment)
            {
                if ([comment.createdAt timeIntervalSinceDate:existingcomment.createdAt] > 0)
                {
                    [dictionary setObject:comment forKey:comment.from.objectId];
                }
            }
            else
            {
                [dictionary setObject:comment forKey:comment.from.objectId];
            }
        }
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    NSArray *sortedInbox = [[dictionary allValues] sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.comments = [sortedInbox mutableCopy];
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"InboxCell";
    InboxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    [cell setComment:comment];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    
    if (comment.request)
    {
        [self performSegueWithIdentifier:REQUEST_DETAIL_SEGUE_IDENTIFIER sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:PERSONAL_MESSAGES_SEGUE_IDENTIFIER sender:self];
    }
}

#pragma mark - Getter & Setter -

- (CommentClient *)commentClient
{
    if (!_commentClient)
    {
        _commentClient = [[CommentClient alloc] init];
    }
    
    return _commentClient;
}

@end
