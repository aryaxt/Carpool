//
//  PersonalMessagesViewController.h
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentClient.h"
#import "CommentCell.h"
#import "MessageComposerView.h"
#import "PushNotificationManager.h"

@interface PersonalMessagesViewController : BaseViewController <MessageComposerViewDelegate, PushNotificationHandler>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) CommentClient *commentClient;
@property (nonatomic, strong) MessageComposerView *messageComposerView;
@property (nonatomic, strong) User *user;

@end
