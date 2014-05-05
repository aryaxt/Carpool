//
//  OfferCell.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarPoolOffer.h"

@class MyOfferCell;
@protocol MyOfferCellDelegate
- (void)myOfferCellDidSelectDelete:(MyOfferCell *)cell;
@end

@interface MyOfferCell : UITableViewCell

@property (nonatomic, weak) id <MyOfferCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UILabel *lblFrom;
@property (nonatomic, strong) IBOutlet UILabel *lblTo;

- (void)setOffer:(CarPoolOffer *)offer;
- (IBAction)deleteSelected:(id)sender;

@end
