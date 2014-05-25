//
//  ProfileViewController.m
//  CarPool
//
//  Created by Aryan on 5/18/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ProfileViewController.h"
#import "CreateReferenceViewController.h"

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
    
    if ([[User currentUser].objectId isEqualToString:self.user.objectId])
    {
        self.btnCreateReference.hidden = YES;
    }
    
    [self fetchAndPopulateReferenceCounts];
}

- (void)fetchAndPopulateReferenceCounts
{
    self.lblPositiveReferenceCount.text = @"";
    self.lblNegativeReferenceCount.text = @"";
    
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
        vc.user = self.user;
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

#pragma mark - Setter & Getter -

- (ReferenceClient *)referenceClient
{
    if (!_referenceClient)
    {
        _referenceClient = [[ReferenceClient alloc] init];
    }
    
    return _referenceClient;
}

@end
