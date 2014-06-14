//
//  RequestDetailViewController.m
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "RequestDetailViewController.h"
#import "UIImageView+Additions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIViewController+Additions.h"
#import <MapKit/MapKit.h>
#import "UIColor+Additions.h"
#import "CarPoolRequestClient.h"
#import "UITableView+Additions.h"
#import "CommentCell.h"
#import "CommentClient.h"
#import "MessageComposerView.h"
#import "ProfileViewController.h"

@interface RequestDetailViewController() <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, MessageComposerViewDelegate>
@property (nonatomic, assign) CGFloat messageComposerHeight;
@property (nonatomic, assign) CGRect mapViewOriginalRect;
@property (nonatomic, strong) UITapGestureRecognizer *mapTapRecognizer;
@property (nonatomic, strong) CarPoolRequestClient *requestClient;
@property (nonatomic, strong) CommentClient *commentClient;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet MessageComposerView *messageComposerView;
@property (nonatomic, strong) IBOutlet UILabel *lblStatusInfo;
@property (nonatomic, strong) IBOutlet UIButton *btnAccept;
@property (nonatomic, strong) IBOutlet UIButton *btnDecline;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;
@property (nonatomic, strong) IBOutlet UIImageView *imgRequesterPhoto;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *comments;
@end

@implementation RequestDetailViewController

#define COMMENT_CELL_IDENTIFIER @"CommentCell"

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.headerView removeFromSuperview];
    
    self.mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mapView.layer.borderWidth = 1;
    self.mapView.layer.cornerRadius = 3;
    self.mapView.scrollEnabled = NO;
    self.mapView.zoomEnabled = NO;
    self.mapViewOriginalRect = self.mapView.frame;
    
    self.btnAccept.layer.cornerRadius = 5;
    self.btnDecline.layer.cornerRadius = 5;
    self.btnCancel.layer.cornerRadius = 5;
    
    self.mapTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.init action:@selector(tapDetectedOnMap:)];
    [self.mapView addGestureRecognizer:self.mapTapRecognizer];
    
    self.messageComposerHeight = self.messageComposerView.frame.size.height;
    
    [self fetchRequestDetail];
    [self fetchComments];
}

#pragma mark - Private Methods -

- (void)setExpandMapView:(BOOL)expand
{
    if (expand)
    {
        self.mapView.scrollEnabled = YES;
        self.mapView.zoomEnabled = YES;
        
        CGRect rectInMainView = [self.tableView convertRect:self.mapView.frame toView:nil];
        [self.mapView removeFromSuperview];
        [self.mapView setFrame:rectInMainView];
        [self.view addSubview:self.mapView];
        
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.mapView.frame = self.view.bounds;
        } completion:^(BOOL finished) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Close Map" style:UIBarButtonItemStyleBordered target:self action:@selector(closeMapSelected)];
            self.navigationItem.rightBarButtonItem = item;
        }];
    }
    else
    {
        self.mapView.scrollEnabled = NO;
        self.mapView.zoomEnabled = NO;
        self.navigationItem.rightBarButtonItem = nil;
        
        CGRect rectInMainView = [self.tableView convertRect:self.mapViewOriginalRect toView:nil];
        
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.mapView.frame = rectInMainView;
        } completion:^(BOOL finished) {
            [self.mapView removeFromSuperview];
            [self.headerView addSubview:self.mapView];
            self.mapView.frame = self.mapViewOriginalRect;
        }];
    }
}

- (void)fetchRequestDetail
{
    [self showLoader];
    
    [self hideRequestStatus];
    
    [self.requestClient fetchRequestById:self.request.objectId withCompletion:^(CarPoolRequest *request, NSError *error) {
        [self hideLoader];
        
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"Error loading offer"];
        }
        else
        {
            self.request = request;
            
            [self.imgRequesterPhoto setUserPhotoStyle];
            [self.imgRequesterPhoto setImageWithURL:[NSURL URLWithString:[self otherUser].photoUrl]
                                   placeholderImage:[UIImage imageNamed:USER_PHOTO_PLACEHOLDER]];
            
            [self updateStatusInfo];
            [self updateActionButtonVisibility];
            [self addPolyline];
        }
    }];
}

- (void)updateActionButtonVisibility
{
    BOOL isRequestFromMe = [self.request.to.objectId isEqualToString:[User currentUser].objectId];
    
    if ([self.request.status isEqualToString:CarPoolRequestStatusCanceled])
    {
        self.btnAccept.hidden = YES;
        self.btnDecline.hidden = YES;
        self.btnCancel.hidden = YES;
    }
    else if (isRequestFromMe)
    {
        self.btnAccept.enabled = ([self.request.status isEqual:CarPoolRequestStatusAccepted]) ? NO : YES;
        self.btnDecline.enabled = ([self.request.status isEqual:CarPoolRequestStatusRejected])  ? NO : YES;
        
        self.btnAccept.hidden = NO;
        self.btnDecline.hidden = NO;
        self.btnCancel.hidden = YES;
    }
    else
    {
        self.btnAccept.hidden = YES;
        self.btnDecline.hidden = YES;
        self.btnCancel.hidden = ([self.request.status isEqualToString:CarPoolRequestStatusAccepted]) ? NO : YES;
    }
}

- (void)updateStatusInfo
{
    NSString *status;
    UIColor *color;
    User *otherUser = ([self isRequestMine]) ? self.request.to : self.request.from;
    
    if (self.request.status)
    {
        color = ([self.request.status isEqual:CarPoolRequestStatusAccepted]) ? [UIColor greenColor] : [UIColor redColor];
        status = (([self isRequestMine] && ![self.request.status isEqual:CarPoolRequestStatusCanceled]) ||
                  (![self isRequestMine] && [self.request.status isEqual:CarPoolRequestStatusCanceled]))
            ? [NSString stringWithFormat:@"%@ has %@ this request", otherUser.name, self.request.status]
            : [NSString stringWithFormat:@"You have %@ this request", self.request.status];
    }
    else
    {
        color = [UIColor darkGrayColor];
        status = ([self isRequestMine])
            ? [NSString stringWithFormat:@"%@ hasn't responded to your request yet", otherUser.name]
            : [NSString stringWithFormat:@"%@ is waiting for your response", otherUser.name];
    }
    
    self.lblStatusInfo.text = status;
    self.lblStatusInfo.textColor = color;
}

- (BOOL)isRequestMine
{
    return ([self.request.from.objectId isEqual:[User currentUser].objectId]) ? YES: NO;
}

- (void)hideRequestStatus
{
    self.btnAccept.hidden = YES;
    self.btnDecline.hidden = YES;
    self.btnCancel.hidden = YES;
}

- (void)fetchComments
{
    [self.messageComposerView setLoading:YES];
    
    [self.commentClient fetchCommentsForRequest:self.request withCompletion:^(NSArray *comments, NSError *error) {
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"Error loading messages"];
        }
        else
        {
            [self.messageComposerView setLoading:NO];
        
            self.comments = (NSMutableArray *)comments;
            [self.tableView deleteRowsAndAnimateNewRows:comments.count inSection:1];
        }
    }];
}

- (User *)otherUser
{
    return ([self.request.from.objectId isEqual:[User currentUser].objectId]) ? self.request.to : self.request.from;
}

- (void)addPolyline
{
    CLLocationCoordinate2D from = CLLocationCoordinate2DMake(
                                                             self.request.startLocation.geoPoint.latitude,
                                                             self.request.startLocation.geoPoint.longitude);
    
    CLLocationCoordinate2D to = CLLocationCoordinate2DMake(
                                                           self.request.endLocation.geoPoint.latitude,
                                                           self.request.endLocation.geoPoint.longitude);
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:from
                                                                                     addressDictionary:nil]];
    
    MKMapItem *toItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to
                                                                                   addressDictionary:nil]];
    
    [request setSource:fromItem];
    [request setDestination:toItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    [request setRequestsAlternateRoutes:YES];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [self showLoader];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        [self hideLoader];
        
        if (!error)
        {
            for (MKRoute *route in [response routes])
            {
                [self.mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
            }
        }
    }];
}

- (void)changeRequestStatus:(NSString *)status
{
    self.btnAccept.enabled = NO;
    self.btnDecline.enabled = NO;
    self.btnCancel.enabled = NO;
    
    [self showLoader];
    
    [self.requestClient updateRequestWithId:self.request.objectId
                                 withStatus:status
                             withCompletion:^(Comment *comment, NSError *error) {
                                 
                                 [self hideLoader];
                                 
                                 if (error)
                                 {
                                     self.btnAccept.enabled = YES;
                                     self.btnDecline.enabled = YES;
                                     [self alertWithtitle:@"Error" andMessage:@"There was a problem responding to this request"];
                                 }
                                 else
                                 {
                                     [self.comments addObject:comment];
                                     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.comments.count-1 inSection:1];
                                     [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                     [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                     
                                     [self updateActionButtonVisibility];
                                     [self updateStatusInfo];
                                 }
    }];
}

#pragma mark - MessageComposerViewDelegate -

- (void)messageComposerViewDidSelectSendWithMessage:(NSString *)message
{
    if (message.length == 0)
    {
        [self alertWithtitle:@"Error" andMessage:@"Message is empty"];
        return;
    }
    
    __weak RequestDetailViewController *weakSelf = self;
    
    [self.messageComposerView resignFirstResponder];
    [self.messageComposerView setLoading:YES];

    [self.commentClient addCommentWithMessage:message toRequest:self.request withCompletion:^(Comment *comment, NSError *error) {
        [weakSelf.messageComposerView setLoading:NO];
        
        if (error)
        {
            [weakSelf alertWithtitle:@"Error" andMessage:@"Error sending comment"];
        }
        else
        {
            // Reset message composer size after message is sent
            [weakSelf.messageComposerView reset];
            weakSelf.messageComposerHeight = weakSelf.messageComposerView.frame.size.height;
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView endUpdates];
            [weakSelf.messageComposerView resizeView];
            
            [weakSelf.comments addObject:comment];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.comments.count-1 inSection:1];
            [weakSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }];
}

- (void)messageComposerViewDidChangeSize
{
    self.messageComposerHeight = self.messageComposerView.frame.size.height;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [self.messageComposerView resizeView];
}

#pragma mark - IBActions -

- (IBAction)tapDetectedOnMap:(id)sender
{
    [self setExpandMapView:YES];
}

- (IBAction)closeMapSelected
{
    [self setExpandMapView:NO];
}

- (IBAction)acceptSelected:(id)sender
{
    [self changeRequestStatus:CarPoolRequestStatusAccepted];
}

- (IBAction)declineSelected:(id)sender
{
    [self changeRequestStatus:CarPoolRequestStatusRejected];
}

- (IBAction)cancelSelected:(id)sender
{
    [self changeRequestStatus:CarPoolRequestStatusCanceled];
}

- (IBAction)profilePhotoSelected:(id)sender
{
    ProfileViewController *vc = [ProfileViewController viewController];
    vc.user = [self otherUser];
    vc.shouldEnableSlideMenu = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 0;
    else
        return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:COMMENT_CELL_IDENTIFIER];
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    BOOL isFromMe = ([comment.from.objectId isEqual:[User currentUser].objectId]) ? YES : NO;
    [cell setComment:comment isFromMe:isFromMe];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    [self.commentClient markCommentAsRead:comment];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:COMMENT_CELL_IDENTIFIER];
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    BOOL isFromMe = ([comment.from.objectId isEqual:[User currentUser].objectId]) ? YES : NO;
    [cell setComment:comment isFromMe:isFromMe];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return self.headerView;
    else
        return self.messageComposerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return self.headerView.frame.size.height;
    else
        return self.messageComposerHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.messageComposerView resignFirstResponder];
}

#pragma mark - PushNotificationHandler -

- (BOOL)canHandlePushNotificationWithType:(NSString *)type andData:(NSDictionary *)data
{
    if ([type isEqualToString:PushNotificationTypeComment] &&
        [self.request.objectId isEqual:[data objectForKey:@"requestId"]])
    {
        NSString *commentId = [data objectForKey:@"commentId"];
        
        [self.commentClient fetchCommentById:commentId withCompletion:^(Comment *comment, NSError *error) {
            if (!error)
            {
                [self.tableView beginUpdates];
                [self.comments addObject:comment];
                NSIndexPath *indeexPath = [NSIndexPath indexPathForRow:self.comments.count-1 inSection:1];
                [self.tableView insertRowsAtIndexPaths:@[indeexPath] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                
                [self.tableView scrollToRowAtIndexPath:indeexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }];
        
        return YES;
    }
    
    return NO;
}

#pragma mark - MKMapViewDelegate -

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor randomColor]];
        [renderer setLineWidth:2.0];
        
        [self.mapView setRegion:MKCoordinateRegionForMapRect([overlay boundingMapRect])
                       animated:YES];
        
        return renderer;
    }
    
    return nil;
}

#pragma mark - Getter & Setter -

- (CarPoolRequestClient *)requestClient
{
    if (!_requestClient)
    {
        _requestClient = [[CarPoolRequestClient alloc] init];
    }
    
    return _requestClient;
}

- (CommentClient *)commentClient
{
    if (!_commentClient)
    {
        _commentClient = [[CommentClient alloc] init];
    }
    
    return _commentClient;
}

- (MessageComposerView *)messageComposerView
{
    if (!_messageComposerView)
    {
        _messageComposerView = [[MessageComposerView alloc] init];
        _messageComposerView.delegate = self;
    }
    
    return _messageComposerView;
}

@end
