//
//  OfferDetailViewController.h
//  CarPool
//
//  Created by Aryan on 5/9/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CarPoolOffer.h"

@protocol HomeOfferDetailViewControllerDelegate <NSObject>
- (void)homeOfferDetailViewControllerDidSelectNext;
- (void)homeOfferDetailViewControllerDidSelectPrevious;
- (void)homeOfferDetailViewControllerDidSelectExpand;
- (void)homeOfferDetailViewControllerDidDetectPan:(UIPanGestureRecognizer *)pan;
- (void)homeOfferDetailViewControllerDidSelectRequestForOffer:(CarPoolOffer *)offer;
- (void)homeOfferDetailViewControllerDidSelectViewUserProfile:(User *)user;
@end

@interface HomeOfferDetailViewController : BaseViewController

@property (nonatomic, weak) id <HomeOfferDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) CarPoolOffer *carPoolOffer;

@end
