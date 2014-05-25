//
//  CommentCell.m
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

#define TEXT_EDGE_INSET 8
#define BOTTOM_SPACE 5
#define MESSAGE_MARGIN 8

- (void)setComment:(Comment *)comment isFromMe:(BOOL)isFromMe
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    self.lblDate.text = [dateFormatter stringFromDate:comment.createdAt];
    self.lblDate.textAlignment = (isFromMe) ? NSTextAlignmentLeft : NSTextAlignmentRight;
    CGRect dateLabelRect = self.lblDate.frame;
    dateLabelRect.size.width = self.frame.size.width - (MESSAGE_MARGIN*2);
    dateLabelRect.origin.x = MESSAGE_MARGIN;
    
    self.lblMessage.text = comment.message;
    self.lblMessage.backgroundColor = [self bubbleColorForComment:comment isFromMe:isFromMe];
    self.lblMessage.textColor = [self textColorForComment:comment isFromMe:isFromMe];
    self.lblMessage.layer.cornerRadius = 12;
    self.lblMessage.edgeInsets = UIEdgeInsetsMake(TEXT_EDGE_INSET, TEXT_EDGE_INSET, TEXT_EDGE_INSET, TEXT_EDGE_INSET);
    
    CGRect labelRect = self.lblMessage.frame;
    labelRect.size.width = self.frame.size.width*8/10;
    self.lblMessage.frame = labelRect;
    
    [self.lblMessage sizeToFit];
    
    labelRect = self.lblMessage.frame;
    labelRect.size.height = labelRect.size.height + TEXT_EDGE_INSET*2;
    labelRect.size.width = labelRect.size.width + TEXT_EDGE_INSET*2;
    labelRect.origin.x = (isFromMe) ? MESSAGE_MARGIN : self.frame.size.width - labelRect.size.width - MESSAGE_MARGIN;
    self.lblMessage.frame = labelRect;
    
    CGRect viewRect = self.frame;
    viewRect.size.height = labelRect.origin.y + labelRect.size.height + BOTTOM_SPACE;
    self.frame = viewRect;
}

#pragma mark - Private Methods -

- (UIColor *)bubbleColorForComment:(Comment *)comment isFromMe:(BOOL)isFromMe
{
    if ([comment.action isEqualToString:CommentActionAccept])
    {
        return [UIColor colorWithRed:94.0/255.0 green:228.0/255.0 blue:67.0/255.0 alpha:1];
    }
    else if ([comment.action isEqualToString:CommentActionReject])
    {
        return [UIColor colorWithRed:255.0/255.0 green:53.0/255.0 blue:36.0/255.0 alpha:1];
    }
    else
    {
        return (isFromMe)
            ? [UIColor colorWithRed:37.0/255.0 green:160.0/255.0 blue:254.0/255.0 alpha:1]
            : [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:234.0/255.0 alpha:1];
    }
    
    return nil;
}

- (UIColor *)textColorForComment:(Comment *)comment isFromMe:(BOOL)isFromMe
{
    if ([comment.action isEqualToString:CommentActionAccept] ||
        [comment.action isEqualToString:CommentActionReject])
    {
        return [UIColor whiteColor];
    }
    else
    {
        return (isFromMe)
            ? [UIColor whiteColor]
            : [UIColor blackColor];
    }
    
    return nil;
}

@end
