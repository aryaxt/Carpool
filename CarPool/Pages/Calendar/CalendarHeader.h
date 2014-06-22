//
//  CalendarHeader.h
//  CarPool
//
//  Created by Aryan on 6/22/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarHeaderDelegate <NSObject>
- (void)calendarHeaderDidSelectNextMonth;
- (void)calendarHeaderDidSelectPreviousMonth;
@end

@interface CalendarHeader : UICollectionReusableView

@property (nonatomic, weak) id <CalendarHeaderDelegate> delegate;

- (void)setDate:(NSDate *)date;

@end
