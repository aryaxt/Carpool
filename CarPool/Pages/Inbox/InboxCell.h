//
//  RequestCell.h
//  CarPool
//
//  Created by Aryan on 5/16/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface InboxCell : UITableViewCell

- (void)setComment:(Comment *)comment withUnreadCount:(NSNumber *)unreadCount;

@end
