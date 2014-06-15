//
//  PersonalMessagesViewController.m
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "PersonalMessagesViewController.h"
#import "UITableView+Additions.h"
#import "CommentClient.h"
#import "CommentCell.h"
#import "MessageComposerView.h"

@interface PersonalMessagesViewController() <MessageComposerViewDelegate>
@property (nonatomic, assign) CGFloat messageComposerHeight;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) CommentClient *commentClient;
@property (nonatomic, strong) MessageComposerView *messageComposerView;
@end

@implementation PersonalMessagesViewController

#define COMMENT_CELL_IDENTIFIER @"CommentCell"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self trackPage:GoogleAnalyticsManagerPagePersonalMessage];
    
    self.messageComposerHeight = self.messageComposerView.frame.size.height;
    
    [self showLoader];
    [self fetchComments];
}

#pragma mark - Private Methods -

- (void)fetchComments
{
    [self.commentClient fetchPersonalCommentsWithUser:self.user withCompletion:^(NSArray *comments, NSError *error) {
        
        [self hideLoader];
        
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"Error loading messages"];
        }
        else
        {
            self.comments = [comments mutableCopy];
            [self.tableView deleteRowsAndAnimateNewRows:comments.count inSection:0];
            [self showNoContent:comments.count ? NO : YES];
        }
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
        NSString *commentId = [data objectForKey:@"commentId"];
        [self.commentClient fetchCommentById:commentId withCompletion:^(Comment *comment, NSError *error) {
            if (!error)
            {
                [self.tableView beginUpdates];
                [self.comments addObject:comment];
                NSIndexPath *indeexPath = [NSIndexPath indexPathForRow:self.comments.count-1 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indeexPath] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                
                [self.tableView scrollToRowAtIndexPath:indeexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
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
