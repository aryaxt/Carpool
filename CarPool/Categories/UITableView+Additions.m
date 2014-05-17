//
//  UITableView+Additions.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "UITableView+Additions.h"

@implementation UITableView (Additions)

- (void)deleteRowsAndAnimateNewRows:(NSInteger)newRows inSection:(NSInteger)section
{
    [self beginUpdates];
    
    for (int i=0 ; i<[self numberOfRowsInSection:section] ; i++)
    {
        [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:section]] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    for (int i=0 ; i<newRows ; i++)
    {
        [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:section]] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self endUpdates];
}

- (void)deleteRowsAndAnimateNewRowsInSectionZero:(NSInteger)newRows
{
    [self deleteRowsAndAnimateNewRows:newRows inSection:0];
}

@end
