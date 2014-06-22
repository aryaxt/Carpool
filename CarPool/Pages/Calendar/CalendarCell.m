//
//  CalendarCell.m
//  CarPool
//
//  Created by Aryan on 6/21/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CalendarCell.h"
#import "NSDate+Additions.h"
#import "UIColor+additions.h"

@interface CalendarCell()
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIView *selectedIndicatorView;
@property (nonatomic, strong) IBOutlet UIView *requestOrOfferIndicatorView;
@end

@implementation CalendarCell

- (void)awakeFromNib
{
    self.requestOrOfferIndicatorView.layer.cornerRadius = self.requestOrOfferIndicatorView.frame.size.width/2;
    self.requestOrOfferIndicatorView.backgroundColor = [UIColor primaryColor];
}

- (void)setDate:(NSDate *)date isInCurrentMonth:(BOOL)isCurrentMonth isSelected:(BOOL)isSelected withOffers:(NSArray *)offers andRequests:(NSArray *)requests
{
    self.lblDate.text = [NSString stringWithFormat:@"%ld", (long)date.day];
    self.hidden = (isCurrentMonth) ? NO : YES;
    self.selectedIndicatorView.hidden = isSelected ? NO : YES;
    self.backgroundColor = (isSelected) ? [UIColor whiteColor] : [UIColor lightBackgroundColor];
    self.requestOrOfferIndicatorView.hidden = (offers.count || requests.count) ? NO : YES;
}

@end
