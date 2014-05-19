//
//  OfferCell.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarPoolOffer.h"

@protocol MyOfferCellDelegate
@end

@interface MyOfferCell : UITableViewCell

@property (nonatomic, weak) id <MyOfferCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UILabel *lblFrom;
@property (nonatomic, strong) IBOutlet UILabel *lblTo;

- (void)setOffer:(CarPoolOffer *)offer;

@end
