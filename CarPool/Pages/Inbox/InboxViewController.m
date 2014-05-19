//
//  InboxViewController.m
//  CarPool
//
//  Created by Aryan on 5/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "InboxViewController.h"

@implementation InboxViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.comments = [NSMutableArray array];
    
    [self showLoader];
    
    [self.commentClient fetchMyCommentsWithCompletion:^(NSArray *comments, NSError *error) {
        [self hideLoader];
        
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"There was a problem loading requests"];
        }
        else
        {
            [self filterAndAddComments:comments];
            [self.tableView deleteRowsAndAnimateNewRowsInSectionZero:self.comments.count];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"RequestDetailViewController"])
    {
        RequestDetailViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Comment *comment = [self.comments objectAtIndex:indexPath.row];
        vc.request = comment.request;
    }
}

#pragma mark - SlideNavigationControllerDelegate -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - PushNotificationHandler -

- (BOOL)canHandlePushNotificationWithType:(NSString *)type
{
    if ([type isEqualToString:PushNotificationTypeComment])
    {
        // Do Stuff
        
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Private Methods -

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
    
    self.comments = [dictionary allValues];
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
        [self performSegueWithIdentifier:@"RequestDetailViewController" sender:self];
    }
    else
    {
        // TODO: Create a comments page and take the user there
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
