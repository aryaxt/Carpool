//
//  ProfileViewController.h
//  CarPool
//
//  Created by Aryan on 5/18/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import <Parse/Parse.h>
#import "UIImageView+Additions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "User.h"
#import "SlideNavigationController.h"
#import "ReferenceClient.h"
#import "CreateReferenceViewController.h"
#import "MessageComposerView.h"
#import "CommentClient.h"

@interface ProfileViewController : BaseViewController <SlideNavigationControllerDelegate, CreateReferenceViewControllerDelegate, MessageComposerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) BOOL shouldEnableSlideMenu;
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

- (IBAction)blockUserSelected:(id)sender;

@end
