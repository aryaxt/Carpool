//
//  RequestOrOfferCell.h
//  CarPool
//
//  Created by Aryan on 6/22/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarPoolOffer.h"
#import "CarPoolRequest.h"

@interface RequestOrOfferCell : UICollectionViewCell

- (void)setOffer:(CarPoolOffer *)offer;
- (void)setRequest:(CarPoolRequest *)request;

@end
