//
//  InboxViewController.h
//  CarPool
//
//  Created by Aryan on 5/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentClient.h"
#import "UITableView+Additions.h"
#import "InboxCell.h"
#import "SlideNavigationController.h"
#import "RequestDetailViewController.h"
#import "PushNotificationManager.h"
#import "PersonalMessagesViewController.h"

@interface InboxViewController : BaseViewController <SlideNavigationControllerDelegate, PushNotificationHandler, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CommentClient *commentClient;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableDictionary *commentCountDictionary;
@property (nonatomic, strong) NSMutableArray *loadingCommentCounts;

@end
