//
//  OfferDetailViewController.h
//  CarPool
//
//  Created by Aryan on 6/15/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CarPoolOffer.h"

@protocol OfferDetailViewControllerDelegate <NSObject>
- (void)offerDetailViewControllerDidDeactivateOffer:(CarPoolOffer *)offer;
@end

@interface OfferDetailViewController : BaseViewController

@property (nonatomic, weak) id <OfferDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) CarPoolOffer *offer;

@end
