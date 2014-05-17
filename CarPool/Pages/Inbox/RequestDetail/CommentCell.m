//
//  CommentCell.m
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)setComment:(Comment *)comment isFromMe:(BOOL)isFromMe
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    self.lblDate.text = [dateFormatter stringFromDate:comment.createdAt];
    self.lblMessage.text = comment.message;
    self.lblMessage.textColor = (isFromMe) ? [UIColor greenColor] : [UIColor blackColor];
}

@end
