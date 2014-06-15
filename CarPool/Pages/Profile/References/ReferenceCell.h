//
//  ReferenceCell.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reference.h"

@class ReferenceCell;
@protocol ReferenceCellDelegate <NSObject>
- (void)referenceCellDidSelectUserProfile:(ReferenceCell *)cell;
@end

@interface ReferenceCell : UITableViewCell

@property (nonatomic, weak) id <ReferenceCellDelegate> delegate;

- (CGRect)setReference:(Reference *)reference isExpanded:(BOOL)expanded;

@end
