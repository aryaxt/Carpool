//
//  CalendarHeader.m
//  CarPool
//
//  Created by Aryan on 6/22/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CalendarHeader.h"

@interface CalendarHeader()
@property (nonatomic, strong) IBOutlet UILabel *lblMonth;
@end

@implementation CalendarHeader

- (void)awakeFromNib
{
    self.layer.borderWidth = .6;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    self.lblMonth.text = [formatter stringFromDate:date];
}

#pragma mark - IBActions -

- (IBAction)nextMonthSelected:(id)sender
{
    [self.delegate calendarHeaderDidSelectNextMonth];
}

- (IBAction)previousMonthSelected:(id)sender
{
    [self.delegate calendarHeaderDidSelectPreviousMonth];
}

@end
