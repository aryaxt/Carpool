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
    self.lblFromName.text = comment.from.username;
    self.lblMessage.text = comment.message;
    self.imgCarpoolrequestIndicator.hidden = (comment.request) ? NO : YES;
    [self.imgFromPhoto setUserPhotoStyle];
    [self.imgFromPhoto setImageWithURL:[NSURL URLWithString:comment.from.photoUrl]
                           placeholderImage:[UIImage imageNamed:@"sfdfgdfg"]];
}

@end
