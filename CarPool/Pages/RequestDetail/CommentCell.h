//
//  CommentCell.h
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentCell : UITableViewCell

- (void)setComment:(Comment *)comment isFromMe:(BOOL)isFromMe;

@end
