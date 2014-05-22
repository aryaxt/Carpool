//
//  ProfileViewController.m
//  CarPool
//
//  Created by Aryan on 5/18/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.imgProfilePicture setUserPhotoStyle];
    [self.imgProfilePicture setImageWithURL:[NSURL URLWithString:self.user.photoUrl]
                           placeholderImage:[UIImage imageNamed:@"adfsdf"]];
    
    self.lblName.text = self.user.name;
    
    if (self.user.profile != nil)
    {
        [self.user.profile fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            self.lblAboutMe.text = self.user.profile.aboutMe;
            self.lblInterests.text = self.user.profile.interests;
            self.lblMusicMoviesBooks.text = self.user.profile.musicMoviesBooks;
        }];
    }
}

#pragma mark - IBActions -

- (IBAction)addFriendSelected:(id)sender
{
    User *currentUser = [User currentUser];
    [currentUser.friends addObject:self.user];
    [currentUser saveEventually];
}

- (IBAction)blockUserSelected:(id)sender
{
    User *currentUser = [User currentUser];
    [currentUser.blockedUsers addObject:self.user];
    [currentUser saveEventually];
}

#pragma mark - SlideNavigationControllerDelegate -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
