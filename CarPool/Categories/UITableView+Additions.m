//
//  UITableView+Additions.m
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "UITableView+Additions.h"

@implementation UITableView (Additions)

- (void)deleteRowsAndAnimateNewRowsIn:(NSInteger)newRows
{
    [self beginUpdates];
    
    for (int i=0 ; i<[self numberOfRowsInSection:0] ; i++)
    {
        [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    for (int i=0 ; i<newRows ; i++)
    {
        [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self endUpdates];
}

@end
