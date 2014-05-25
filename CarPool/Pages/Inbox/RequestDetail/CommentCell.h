//
//  CommentCell.h
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "InsetEnabledLabel.h"

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet InsetEnabledLabel *lblMessage;

- (void)setComment:(Comment *)comment isFromMe:(BOOL)isFromMe;

@end
