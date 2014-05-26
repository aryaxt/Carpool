//
//  RequestDetailViewController.m
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "RequestDetailViewController.h"

@interface RequestDetailViewController()
@property (nonatomic, assign) CGFloat messageComposerHeight;
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
    
    self.messageComposerHeight = self.messageComposerView.frame.size.height;
    
    [self fetchRequestDetail];
    [self fetchCommentsAnimated:YES withCompletion:nil];
}

#pragma mark - Private Methods -

- (void)fetchRequestDetail
{
    [self showLoader];
    
    [self hideAcceptanceStatus];
    
    [self.requestClient fetchRequestById:self.request.objectId withCompletion:^(CarPoolRequest *request, NSError *error) {
        [self hideLoader];
        
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"Error loading offer"];
        }
        else
        {
            self.request = request;
            
            self.lblRequesterName.text = self.request.to.name;
            [self.imgRequesterPhoto setUserPhotoStyle];
            [self.imgRequesterPhoto setImageWithURL:[NSURL URLWithString:self.request.to.photoUrl]
                                   placeholderImage:[UIImage imageNamed:@"sfdfgdfg"]];
            
            [self updateAcceptanceStatus];
            
            [self addPolyline];
        }
    }];
}

- (void)updateAcceptanceStatus
{
    BOOL isRequestFromMe = [self.request.to.objectId isEqualToString:[User currentUser].objectId];
    
    if (self.request.status && !isRequestFromMe)
    {
        self.lblStatusInfo.hidden = NO;
        self.lblStatusInfo.text = (self.request.status.boolValue) ? @"Accepted" : @"Declined";
        self.lblStatusInfo.textColor = (self.request.status.boolValue) ? [UIColor greenColor] : [UIColor redColor];
    }
    else
    {
        if (isRequestFromMe)
        {
            self.btnAccept.titleLabel.textColor = (self.request.status.boolValue) ?
                [UIColor greenColor] :
                [UIColor lightGrayColor];
            self.btnDecline.titleLabel.textColor = (self.request.status.boolValue) ?
                [UIColor lightGrayColor] :
                [UIColor redColor];

            self.btnAccept.hidden = NO;
            self.btnDecline.hidden = NO;
        }
        else
        {
            self.lblStatusInfo.hidden = NO;
            self.lblStatusInfo.text = @"Request Pending";
        }
    }
}

- (void)hideAcceptanceStatus
{
    self.btnAccept.titleLabel.textColor = [UIColor lightGrayColor];
    self.btnDecline.titleLabel.textColor = [UIColor lightGrayColor];
    self.btnAccept.hidden = YES;
    self.btnDecline.hidden = YES;
    self.lblStatusInfo.hidden = YES;
}

- (void)fetchCommentsAnimated:(BOOL)animated withCompletion:(void (^)(void))completion
{
    [self.messageComposerView setLoading:YES];
    
    [self.commentClient fetchCommentsForRequest:self.request withCompletion:^(NSArray *comments, NSError *error) {
        //TODO: Some error handling here?
        [self.messageComposerView setLoading:NO];
        
        self.comments = (NSMutableArray *)comments;
        
        if (animated)
            [self.tableView deleteRowsAndAnimateNewRows:comments.count inSection:1];
        else
            [self.tableView reloadData];
        
        if (completion)
            completion();
    }];
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

- (void)changeRequestStatus:(BOOL)status
{
    self.btnAccept.enabled = NO;
    self.btnDecline.enabled = NO;
    
    [self.requestEngine updateRequest:self.request
                           withStatus:status
                        andCompletion:^(Comment *comment, NSError *error) {
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
            
            [self updateAcceptanceStatus];
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

- (IBAction)acceptSelected:(id)sender
{
    [self changeRequestStatus:YES];
}

- (IBAction)declineSelected:(id)sender
{
    [self changeRequestStatus:NO];
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
        [self fetchCommentsAnimated:NO withCompletion:^{
            NSIndexPath *indeexPath = [NSIndexPath indexPathForRow:self.comments.count-1 inSection:1];
            [self.tableView scrollToRowAtIndexPath:indeexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

- (CarPoolRequestEngine *)requestEngine
{
    if (!_requestEngine)
    {
        _requestEngine = [[CarPoolRequestEngine alloc] init];
    }
    
    return _requestEngine;
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
