//
//  PersonalMessagesViewController.m
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "PersonalMessagesViewController.h"
#import "UITableView+Additions.h"

@interface PersonalMessagesViewController()
@property (nonatomic, assign) CGFloat messageComposerHeight;
@end

@implementation PersonalMessagesViewController

#define COMMENT_CELL_IDENTIFIER @"CommentCell"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.messageComposerHeight = self.messageComposerView.frame.size.height;
    
    [self showLoader];
    [self fetchCommentsAnimated:YES withCompletion:nil];
}

#pragma mark - Private Methods -

- (void)fetchCommentsAnimated:(BOOL)animated withCompletion:(void (^)(void))completion
{
    [self.commentClient fetchPersonalCommentsWithUser:self.user withCompletion:^(NSArray *comments, NSError *error) {
        
        [self hideLoader];
        
        self.comments = [comments mutableCopy];
        
        if (animated)
            [self.tableView deleteRowsAndAnimateNewRows:comments.count inSection:0];
        else
            [self.tableView reloadData];
        
        if (completion)
            completion();
    }];
}

#pragma mark - UITableView Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:COMMENT_CELL_IDENTIFIER];
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    BOOL isFromMe = ([comment.from.objectId isEqual:[User currentUser].objectId]) ? YES : NO;
    [cell setComment:comment isFromMe:isFromMe];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    [self.commentClient markCommentAsRead:comment];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:COMMENT_CELL_IDENTIFIER];
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    BOOL isFromMe = ([comment.from.objectId isEqual:[User currentUser].objectId]) ? YES : NO;
    [cell setComment:comment isFromMe:isFromMe];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.messageComposerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.messageComposerHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.messageComposerView resignFirstResponder];
}

#pragma mark - MessageComposerViewDelegate -

- (void)messageComposerViewDidSelectSendWithMessage:(NSString *)message
{
    if (message.length == 0)
    {
        [self alertWithtitle:@"Error" andMessage:@"Message is empty"];
        return;
    }
    
    __weak PersonalMessagesViewController *weakSelf = self;
    
    [self.messageComposerView resignFirstResponder];
    [self.messageComposerView setLoading:YES];
    
    [self.commentClient sendCommentWithMessage:message toUser:self.user withCompletion:^(Comment *comment, NSError *error) {
        [weakSelf.messageComposerView setLoading:NO];
        
        if (error)
        {
            [weakSelf alertWithtitle:@"Error" andMessage:@"Error sending comment"];
        }
        else
        {
            // Reset message composer size after message is sent
            [weakSelf.messageComposerView reset];
            weakSelf.messageComposerHeight = weakSelf.messageComposerView.frame.size.height;
            [weakSelf.messageComposerView resizeView];
            
            [weakSelf.comments addObject:comment];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.comments.count-1 inSection:0];
            [weakSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }];
}

- (void)messageComposerViewDidChangeSize
{
    self.messageComposerHeight = self.messageComposerView.frame.size.height;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [self.messageComposerView resizeView];
}

#pragma mark - PushNotificationHandler -

- (BOOL)canHandlePushNotificationWithType:(NSString *)type andData:(NSDictionary *)data
{
    if ([type isEqualToString:PushNotificationTypeComment] &&
        [self.user.objectId isEqual:[data objectForKey:@"fromId"]])
    {
        [self fetchCommentsAnimated:NO withCompletion:^{
            NSIndexPath *indeexPath = [NSIndexPath indexPathForRow:self.comments.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indeexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Setter & Getter -

- (CommentClient *)commentClient
{
    if (!_commentClient)
    {
        _commentClient = [[CommentClient alloc] init];
    }
    
    return _commentClient;
}

- (MessageComposerView *)messageComposerView
{
    if (!_messageComposerView)
    {
        _messageComposerView = [[MessageComposerView alloc] init];
        _messageComposerView.delegate = self;
    }
    
    return _messageComposerView;
}

@end
