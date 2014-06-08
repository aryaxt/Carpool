//
//  RequestCell.m
//  CarPool
//
//  Created by Aryan on 5/16/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "InboxCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImageView+Additions.h"
#import "NSDate+TimeAgo.h"

@interface InboxCell()
@property (nonatomic, strong) IBOutlet UILabel *lblFromName;
@property (nonatomic, strong) IBOutlet UILabel *lblMessage;
@property (nonatomic, strong) IBOutlet UILabel *lblTimeAgo;
@property (nonatomic, strong) IBOutlet UILabel *lblUnreadCount;
@property (nonatomic, strong) IBOutlet UIImageView *imgFromPhoto;
@property (nonatomic, strong) IBOutlet UIImageView *imgCarpoolrequestIndicator;
@end

@implementation InboxCell

- (void)setComment:(Comment *)comment withUnreadCount:(NSNumber *)unreadCount
{
    User *otherUser = ([comment.from.objectId isEqual:[User currentUser].objectId])
        ? comment.to
        :comment.from;
    
    self.lblMessage.text = ([comment.from.objectId isEqual:[User currentUser].objectId])
        ? [NSString stringWithFormat:@"You: %@", comment.message]
        : comment.message;
    
    BOOL unread = (unreadCount && unreadCount.intValue > 0) ? YES : NO;
    
    self.lblUnreadCount.text = (unread) ? unreadCount.stringValue : @"";
    self.lblTimeAgo.text = [comment.createdAt timeAgo];
    self.lblFromName.text = otherUser.username;
    self.lblFromName.font = (unread) ?[UIFont boldSystemFontOfSize:14] : [UIFont systemFontOfSize:14];
    self.imgCarpoolrequestIndicator.hidden = (comment.request) ? NO : YES;
    [self.imgFromPhoto setUserPhotoStyle];
    [self.imgFromPhoto setImageWithURL:[NSURL URLWithString:otherUser.photoUrl]
                           placeholderImage:[UIImage imageNamed:@"sfdfgdfg"]];
}

@end
