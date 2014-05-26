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
        [self fetchAndPopulateDataAnimated:NO withCompletion:^{
            // Do some animation to tell the user they recieved a new message
        }];
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Private Methods -

- (void)fetchAndPopulateDataAnimated:(BOOL)animated withCompletion:(void (^)(void))completion
{
    [self.commentClient fetchMyCommentsWithCompletion:^(NSArray *comments, NSError *error) {
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
