//
//  CalendarCell.h
//  CarPool
//
//  Created by Aryan on 6/21/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UICollectionViewCell

- (void)setDate:(NSDate *)date isInCurrentMonth:(BOOL)isCurrentMonth isSelected:(BOOL)isSelected withOffers:(NSArray *)offers andRequests:(NSArray *)requests;

@end
