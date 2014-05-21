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
@end

@interface OfferDetailViewController : BaseViewController

@property (nonatomic, weak) id <OfferDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) CarPoolOffer *carPoolOffer;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblStartLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblEndLocation;
@property (nonatomic, strong) IBOutlet UITextView *lblMessage;
@property (nonatomic, strong) IBOutlet UIImageView *offerOwnerPhoto;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *btnTitle;

- (IBAction)nextSelected:(id)sender;
- (IBAction)previousSelected:(id)sender;
- (IBAction)titleSelected:(id)sender;
- (IBAction)requestOfferSelected:(id)sender;

@end
