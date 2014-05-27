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

@implementation InboxCell

- (void)setComment:(Comment *)comment
{
    User *otherUser = ([comment.from.objectId isEqual:[User currentUser].objectId])
        ? comment.to
        :comment.from;
    
    self.lblMessage.text = ([comment.from.objectId isEqual:[User currentUser].objectId])
        ? [NSString stringWithFormat:@"You: %@", comment.message]
        : comment.message;
    
    self.lblFromName.text = otherUser.username;
    self.imgCarpoolrequestIndicator.hidden = (comment.request) ? NO : YES;
    [self.imgFromPhoto setUserPhotoStyle];
    [self.imgFromPhoto setImageWithURL:[NSURL URLWithString:otherUser.photoUrl]
                           placeholderImage:[UIImage imageNamed:@"sfdfgdfg"]];
}

@end
