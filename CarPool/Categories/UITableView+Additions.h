//
//  UITableView+Additions.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Additions)

- (void)deleteRowsAndAnimateNewRowsInSectionZero:(NSInteger)newRows;
- (void)deleteRowsAndAnimateNewRows:(NSInteger)newRows inSection:(NSInteger)section;
- (void)deleteRowsAndAnimateNewRows:(NSInteger)newRows inSection:(NSInteger)section withDeleteAnimatiion:(UITableViewRowAnimation)deleteAnimation andInsertAnimation:(UITableViewRowAnimation)insertAnimation;

@end
