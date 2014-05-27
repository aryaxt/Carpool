//
//  RequestDetailViewController.h
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "CarPoolRequest.h"
#import "UIImageView+Additions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MapKit/MapKit.h>
#import "UIColor+Additions.h"
#import "CarPoolRequestClient.h"
#import "UITableView+Additions.h"
#import "CommentCell.h"
#import "CommentClient.h"
#import "CarPoolRequestEngine.h"
#import "PushNotificationManager.h"
#import "MessageComposerView.h"

@interface RequestDetailViewController : BaseViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, PushNotificationHandler, MessageComposerViewDelegate>

@property (nonatomic, strong) CarPoolRequest *request;
@property (nonatomic, strong) CarPoolRequestEngine *requestEngine;
@property (nonatomic, strong) CarPoolRequestClient *requestClient;
@property (nonatomic, strong) CommentClient *commentClient;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet MessageComposerView *messageComposerView;
@property (nonatomic, strong) IBOutlet UILabel *lblRequesterName;
@property (nonatomic, strong) IBOutlet UILabel *lblStatusInfo;
@property (nonatomic, strong) IBOutlet UIButton *btnAccept;
@property (nonatomic, strong) IBOutlet UIButton *btnDecline;
@property (nonatomic, strong) IBOutlet UIImageView *imgRequesterPhoto;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *comments;

- (IBAction)acceptSelected:(id)sender;
- (IBAction)declineSelected:(id)sender;

@end