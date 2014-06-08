//
//  ReferenceCell.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reference.h"

@interface ReferenceCell : UITableViewCell

- (CGRect)setReference:(Reference *)reference isExpanded:(BOOL)expanded;

@end
