//
//  OfferDetailViewController.h
//  CarPool
//
//  Created by Aryan on 5/9/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CarPoolOffer.h"

@protocol OfferDetailViewControllerDelegate <NSObject>
- (void)offerDetailViewControllerDidSelectNext;
- (void)offerDetailViewControllerDidSelectPrevious;
- (void)offerDetailViewControllerDidSelectExpand;
- (void)offerDetailViewControllerDidDetectPan:(UIPanGestureRecognizer *)pan;
- (void)offerDetailViewControllerDidSelectRequestForOffer:(CarPoolOffer *)offer;
- (void)offerDetailViewControllerDidSelectViewUserProfile:(User *)user;
@end

@interface OfferDetailViewController : BaseViewController

@property (nonatomic, weak) id <OfferDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) CarPoolOffer *carPoolOffer;

@end
