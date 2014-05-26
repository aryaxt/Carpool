//
//  ProfileViewController.m
//  CarPool
//
//  Created by Aryan on 5/18/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ProfileViewController.h"
#import "ReferencesViewController.h"

@interface ProfileViewController()
@property (nonatomic, strong) NSDictionary *keyBoardInfo;
@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.lblName.text = self.user.name;
    [self.imgProfilePicture setUserPhotoStyle];
    [self.imgProfilePicture setImageWithURL:[NSURL URLWithString:self.user.photoUrl]
                           placeholderImage:[UIImage imageNamed:@"adfsdf"]];
    
    if ([[User currentUser].objectId isEqualToString:self.user.objectId])
    {
        self.btnCreateReference.hidden = YES;
    }
    else
    {
        [self addMessageComposerView];
    }
    
    self.lblPositiveReferenceCount.text = @"";
    self.lblNegativeReferenceCount.text = @"";
    [self fetchAndPopulateReferenceCounts];
    
    [self handleKeyboardNotifications];
}

- (void)handleKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.keyBoardInfo = note.userInfo;
                                                      [self animateMessageComposerLocation:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.keyBoardInfo = note.userInfo;
                                                      [self animateMessageComposerLocation:YES];
                                                  }];
}

- (void)animateMessageComposerLocation:(BOOL)hide
{
    CGFloat animationDuration = [[self.keyBoardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect messageRect = self.messageComposerView.frame;
    
    if (!hide)
    {
        
        NSValue *keyboardFrameBegin = [self.keyBoardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        messageRect.origin.y = messageRect.origin.y - keyboardFrameBeginRect.size.height;
    }
    else
    {
        CGRect messageRect = self.messageComposerView.frame;
        messageRect.origin.y = self.contentScrollView.frame.size.height + self.contentScrollView.frame.origin.y;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.messageComposerView.frame = messageRect;
    }];
}

- (void)addMessageComposerView
{
    CGRect contentScrollViewFrame = self.contentScrollView.frame;
    contentScrollViewFrame.size.height = contentScrollViewFrame.size.height - self.messageComposerView.frame.size.height;
    self.contentScrollView.frame = contentScrollViewFrame;
    
    [self.view addSubview:self.messageComposerView];
    
    CGRect messageRect = self.messageComposerView.frame;
    messageRect.origin.y = contentScrollViewFrame.size.height + contentScrollViewFrame.origin.y;
    self.messageComposerView.frame = messageRect;
}

- (void)fetchAndPopulateProfile
{
    if (self.user.profile != nil)
    {
        [self.user.profile fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            self.lblAboutMe.text = self.user.profile.aboutMe;
            self.lblInterests.text = self.user.profile.interests;
            self.lblMusicMoviesBooks.text = self.user.profile.musicMoviesBooks;
        }];
    }
}

- (void)fetchAndPopulateReferenceCounts
{
    [self.referenceClient fetchReferenceCountsForUser:self.user withCompletion:^(NSNumber *poitive, NSNumber *negative, NSError *error) {
        if (!error)
        {
            self.lblPositiveReferenceCount.text = poitive.stringValue;
            self.lblNegativeReferenceCount.text = negative.stringValue;
        }
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

#pragma mark - SlideNavigationControllerDelegate -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - UIScrollViewDelegate -

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
