//
//  CreateOfferStepsViewController.h
//  CarPool
//
//  Created by Aryan on 6/1/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "StepsViewController.h"
#import "CarPoolOffer.h"

@protocol CreateOfferStepsViewControllerDelegate
- (void)createOfferStepsViewControllerDidCreateOffer:(CarPoolOffer *)offer;
@end

@interface CreateOfferStepsViewController : StepsViewController

@property (nonatomic, weak) id <CreateOfferStepsViewControllerDelegate> delegate;

@end
