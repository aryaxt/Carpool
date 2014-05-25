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

@interface ProfileViewController : BaseViewController <SlideNavigationControllerDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) IBOutlet UIImageView *imgProfilePicture;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblAboutMe;
@property (nonatomic, strong) IBOutlet UILabel *lblInterests;
@property (nonatomic, strong) IBOutlet UILabel *lblPositiveReferenceCount;
@property (nonatomic, strong) IBOutlet UILabel *lblNegativeReferenceCount;
@property (nonatomic, strong) IBOutlet UILabel *lblMusicMoviesBooks;
@property (nonatomic, strong) IBOutlet UIButton *btnCreateReference;
@property (nonatomic, strong) ReferenceClient *referenceClient;

- (IBAction)addFriendSelected:(id)sender;
- (IBAction)blockUserSelected:(id)sender;

@end
