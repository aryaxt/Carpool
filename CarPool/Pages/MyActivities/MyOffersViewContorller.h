//
//  OffersViewContorller.h
//  CarPool
//
//  Created by Aryan on 5/28/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CarPoolOffer.h"

@protocol MyOffersViewContorllerDelegate <NSObject>
- (void)MyOffersViewContorllerDidSelectOffer:(CarPoolOffer *)offer;
@end

@interface MyOffersViewContorller : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <MyOffersViewContorllerDelegate> delegate;

- (void)addNewOffer:(CarPoolOffer *)offer;

@end
