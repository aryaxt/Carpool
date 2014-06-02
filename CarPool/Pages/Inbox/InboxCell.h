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

@property (nonatomic, strong) IBOutlet UILabel *lblFromName;
@property (nonatomic, strong) IBOutlet UILabel *lblMessage;
@property (nonatomic, strong) IBOutlet UILabel *lblTimeAgo;
@property (nonatomic, strong) IBOutlet UILabel *lblUnreadCount;
@property (nonatomic, strong) IBOutlet UIImageView *imgFromPhoto;
@property (nonatomic, strong) IBOutlet UIImageView *imgCarpoolrequestIndicator;

- (void)setComment:(Comment *)comment withUnreadCount:(NSNumber *)unreadCount;

@end
