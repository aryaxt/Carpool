//
//  RequestDetailViewController.m
//  CarPool
//
//  Created by Aryan on 5/17/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "RequestDetailViewController.h"

@implementation RequestDetailViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.headerView removeFromSuperview];
    [self.commentHeaderView removeFromSuperview];
    
    self.mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mapView.layer.borderWidth = 1;
    self.mapView.layer.cornerRadius = 3;
    
    self.txtNewMessage.text = @"";
    self.txtNewMessage.layer.borderWidth = .6;
    self.txtNewMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txtNewMessage.layer.cornerRadius = 5;
    
    [self fetchRequestDetail];
    [self fetchComments];
}

#pragma mark - Private Methods -

- (void)fetchRequestDetail
{
    [self showLoader];
    
    self.btnAccept.hidden = YES;
    self.btnDecline.hidden = YES;
    self.lblStatusInfo.hidden = YES;
    
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
            
            BOOL isRequestFromMe = [self.request.to.objectId isEqualToString:[User currentUser].objectId];
            
            if (request.status)
            {
                self.lblStatusInfo.hidden = NO;
                self.lblStatusInfo.text = (request.status.boolValue) ? @"Accepted" : @"Declined";
                self.lblStatusInfo.textColor = (request.status.boolValue) ? [UIColor greenColor] : [UIColor redColor];
            }
            else
            {
                if (isRequestFromMe)
                {
                    self.btnAccept.hidden = NO;
                    self.btnDecline.hidden = NO;
                }
                else
                {
                    self.lblStatusInfo.hidden = NO;
                    self.lblStatusInfo.text = @"Request Pending";
                }
            }
            
            [self addPolyline];
        }
    }];
}

- (void)fetchComments
{
    [self.loadCommentIndicatorView startAnimating];
    self.btnSendMessage.hidden = YES;
    
    [self.commentClient fetchCommentsForRequest:self.request withCompletion:^(NSArray *comments, NSError *error) {
        //TODO: Some error handling here?
        self.btnSendMessage.hidden = NO;
        [self.loadCommentIndicatorView stopAnimating];
        
        self.comments = (NSMutableArray *)comments;
        [self.tableView deleteRowsAndAnimateNewRows:comments.count inSection:1];
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
    
    [self.requestEngine updateRequest:self.request withStatus:status andCompletion:^(NSError *error) {
        if (error)
        {
            self.btnAccept.enabled = YES;
            self.btnDecline.enabled = YES;
            [self alertWithtitle:@"Error" andMessage:@"There was a problem responding to this request"];
        }
        else
        {
            // Update state after success
        }
    }];
}

#pragma mark - IBActions -

- (IBAction)sendSelected:(id)sender
{
    Comment *comment = [[Comment alloc] init];
    comment.message = self.txtNewMessage.text;
    comment.from = [User currentUser];
    comment.to = ([[User currentUser].objectId isEqualToString:self.request.from.objectId])
        ? self.request.to
        : self.request.from;
    
    __weak RequestDetailViewController *weakSelf = self;
    
    [self.loadCommentIndicatorView startAnimating];
    self.btnSendMessage.hidden = YES;
    [self.txtNewMessage resignFirstResponder];
    
    [self.commentClient addComment:comment
                         toRequest:self.request
                    withCompletion:^(NSError *error) {
                        [weakSelf.loadCommentIndicatorView stopAnimating];
                        weakSelf.btnSendMessage.hidden = NO;
                        
                        if (error)
                        {
                            [weakSelf alertWithtitle:@"Error" andMessage:@"Error sending comment"];
                        }
                        else
                        {
                            weakSelf.txtNewMessage.text = @"";
                            [weakSelf.comments addObject:comment];
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.comments.count-1 inSection:1];
                            [weakSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        }
    }];
}

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
    static NSString *cellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    BOOL isFromMe = ([comment.from.objectId isEqual:[User currentUser].objectId]) ? YES : NO;
    [cell setComment:comment isFromMe:isFromMe];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    BOOL isToMe = ([comment.to.objectId isEqual:[User currentUser].objectId]) ? YES : NO;
    
    if (isToMe)
    {
        if (!comment.read.boolValue)
        {
            comment.read = @YES;
            [comment saveEventually];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return self.headerView;
    else
        return self.commentHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return self.headerView.frame.size.height;
    else
        return self.commentHeaderView.frame.size.height;
}

#pragma mark - UITextViewDelegate -


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

@end
