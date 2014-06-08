//
//  ProfileViewController.m
//  CarPool
//
//  Created by Aryan on 5/18/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ProfileViewController.h"
#import "ReferencesViewController.h"
#import <Parse/Parse.h>
#import "UIImageView+Additions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SlideNavigationController.h"
#import "ReferenceClient.h"
#import "CreateReferenceViewController.h"
#import "MessageComposerView.h"
#import "CommentClient.h"

@interface ProfileViewController() <SlideNavigationControllerDelegate, CreateReferenceViewControllerDelegate, MessageComposerViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) BOOL referencesFetched;
@property (nonatomic, assign) CGFloat messageComposerHeight;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *imgProfilePicture;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblPositiveReferenceCount;
@property (nonatomic, strong) IBOutlet UILabel *lblNegativeReferenceCount;
@property (nonatomic, strong) IBOutlet UILabel *lblMemberSince;
@property (nonatomic, strong) IBOutlet UILabel *lblAge;
@property (nonatomic, strong) IBOutlet UIView *referencesView;
@property (nonatomic, strong) IBOutlet UIView *userInfoView;
@property (nonatomic, strong) IBOutlet UIView *aboutMeView;
@property (nonatomic, strong) IBOutlet UIView *mediaView;
@property (nonatomic, strong) IBOutlet UIView *interestesView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *referencesLoader;
@property (nonatomic, strong) IBOutlet UIButton *btnCreateReference;
@property (nonatomic, strong) ReferenceClient *referenceClient;
@property (nonatomic, strong) MessageComposerView *messageComposerView;
@property (nonatomic, strong) CommentClient *commentClient;
@end

@implementation ProfileViewController

#define REFERENCE_VIEW_RIGHT_OFFSET 20

#pragma mark - UIViewController MEthods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.shouldEnableSlideMenu = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.messageComposerHeight = self.messageComposerView.frame.size.height;
    
    self.lblMemberSince.text = [dateFormatter stringFromDate:self.user.createdAt];
    self.lblAge.text = self.user.age.stringValue;
    self.lblName.text = self.user.name;
    [self.imgProfilePicture setUserPhotoStyle];
    [self.imgProfilePicture setImageWithURL:[NSURL URLWithString:self.user.photoUrl]
                           placeholderImage:[UIImage imageNamed:@"adfsdf"]];
    
    if ([self userIsCurrentUser])
    {
        self.btnCreateReference.hidden = YES;
    }

    self.mediaView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mediaView.layer.borderWidth = .6;
    self.interestesView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.interestesView.layer.borderWidth = .6;
    self.aboutMeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.aboutMeView.layer.borderWidth = .6;
    self.referencesView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.referencesView.layer.borderWidth = .6;
    self.referencesView.layer.cornerRadius = 20;
    self.referencesView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.referencesView.layer.shadowRadius = 2;
    self.referencesView.layer.shadowOpacity = .8;
    self.referencesView.layer.shadowOffset = CGSizeMake(1, 1);
    
    UITapGestureRecognizer *tapREcognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(referencesSelected:)];
    [self.referencesView addGestureRecognizer:tapREcognizer];
    
    
    self.lblPositiveReferenceCount.text = @"";
    self.lblNegativeReferenceCount.text = @"";
    
    [self fetchAndPopulateReferenceCounts];
    [self fetchAndPopulateProfile];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.referencesFetched)
    {
        [self showReferences:YES animated:YES withCompletion:nil];
    }
}

#pragma mark - Private Methods -

- (BOOL)userIsCurrentUser
{
    return ([[User currentUser].objectId isEqualToString:self.user.objectId]);
}

- (void)fetchAndPopulateProfile
{
    [self.user.profile fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.tableView reloadData];
    }];
}

- (void)fetchAndPopulateReferenceCounts
{
    [self.referencesLoader startAnimating];
    
    CGRect originalRect = self.referencesView.frame;
    CGRect newRect = originalRect;
    newRect.origin.x = self.view.frame.size.width;
    
    [self.referenceClient fetchReferenceCountsForUser:self.user withCompletion:^(NSNumber *poitive, NSNumber *negative, NSError *error){
        [self.referencesLoader stopAnimating];
        
        if (!error)
        {
            self.referencesFetched = YES;
            self.lblPositiveReferenceCount.text = poitive.stringValue;
            self.lblNegativeReferenceCount.text = negative.stringValue;
            
            [self showReferences:YES animated:YES withCompletion:nil];
        }
    }];
}

- (void)showReferences:(BOOL)show animated:(BOOL)animated withCompletion:(void (^)(void))completion
{
    CGRect newRect = self.referencesView.frame;
    newRect.origin.x =  (show)
        ? self.view.frame.size.width - newRect.size.width + REFERENCE_VIEW_RIGHT_OFFSET
        : self.view.frame.size.width;
    
    [UIView animateWithDuration:(animated) ? .25 : 0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.referencesView.frame = newRect;
    } completion:^(BOOL finished) {
        if (completion)
            completion();
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CreateReferenceViewController"])
    {
        CreateReferenceViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.user = self.user;
    }
    else if ([segue.identifier isEqualToString:@"ReferencesViewController"])
    {
        ReferencesViewController *vc = segue.destinationViewController;
        vc.user = self.user;
    }
}

#pragma mark - CreateReferenceViewControllerDelegate -

- (void)CreateReferenceViewControllerDidSubmitReference:(Reference *)reference
{
    [self fetchAndPopulateReferenceCounts];
}

#pragma mark - IBActions -

- (IBAction)blockUserSelected:(id)sender
{
    User *currentUser = [User currentUser];
    [currentUser.blockedUsers addObject:self.user];
    [currentUser saveEventually];
}

- (void)referencesSelected:(id)sender
{
    [self showReferences:NO animated:YES withCompletion:^{
       [self performSegueWithIdentifier:@"ReferencesViewController" sender:self];
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
    
    [self.messageComposerView setLoading:YES];
    
   [self.commentClient sendCommentWithMessage:message
                                       toUser:self.user
                               withCompletion:^(Comment *comment, NSError *error) {
       
                                   [self.messageComposerView setLoading:NO];
                                   
                                   if (error)
                                   {
                                       [self alertWithtitle:@"Error" andMessage:@"There was a problem saving the comment"];
                                   }
                                   else
                                   {
                                        [self.messageComposerView reset];
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

#pragma mark - SlideNavigationControllerDelegate -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return self.shouldEnableSlideMenu;
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2 ||
        section == 3 ||
        section == 4)
    {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger OFFSET = 10;
    NSString *text = nil;
    
    if (indexPath.section == 2)
    {
        text = self.user.profile.aboutMe;
    }
    else if (indexPath.section == 3)
    {
        text = self.user.profile.interests;
    }
    else if (indexPath.section == 4)
    {
        text = self.user.profile.media;
    }
    else
    {
        return nil;
    }
    
    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.text = (text) ? text : @"Nothihg here yet";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileInfoCell"];
    [cell.contentView addSubview:textView];
    textView.frame = CGRectInset(cell.frame, OFFSET, OFFSET);
    [textView sizeToFit];
    
    CGRect rect = cell.frame;
    rect.size.height = textView.frame.size.height + textView.frame.origin.y + OFFSET;
    cell.frame = rect;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.userInfoView;
    }
    else if (section == 1)
    {
        return ([self userIsCurrentUser]) ? nil : self.messageComposerView;
    }
    else if (section == 2)
    {
        return self.aboutMeView;
    }
    else if (section == 3)
    {
        return self.interestesView;
    }
    else
    {
        return self.mediaView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.userInfoView.frame.size.height;
    }
    else if (section == 1)
    {
        return ([self userIsCurrentUser]) ? 0 : self.messageComposerHeight;
    }
    else if (section == 2)
    {
        return self.aboutMeView.frame.size.height;
    }
    else if (section == 3)
    {
        return self.interestesView.frame.size.height;
    }
    else
    {
        return self.mediaView.frame.size.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.messageComposerView resignFirstResponder];
}

#pragma mark - Setter & Getter -

- (ReferenceClient *)referenceClient
{
    if (!_referenceClient)
    {
        _referenceClient = [[ReferenceClient alloc] init];
    }
    
    return _referenceClient;
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

- (CommentClient *)commentClient
{
    if (!_commentClient)
    {
        _commentClient = [[CommentClient alloc] init];
    }
    
    return _commentClient;
}

@end
