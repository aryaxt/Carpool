//
//  OfferDetailViewController.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "CarPoolOffer.h"

@interface OfferDetailViewController : BaseViewController

@property (nonatomic, strong) CarPoolOffer *offer;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblStartLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblEndLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblMessage;
@property (nonatomic, strong) IBOutlet UILabel *lblOfferOwner;
@property (nonatomic, strong) IBOutlet UIImageView *lblOfferOwnerPhoto;

@end
