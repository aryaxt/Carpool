//
//  CreateReferenceViewController.m
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CreateReferenceViewController.h"
#import "UIImageView+Additions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIAlertView+Blocks.h"
#import "ReferenceClient.h"

@interface CreateReferenceViewController ()
@property (nonatomic, strong) IBOutlet UITextView *txtReference;
@property (nonatomic, strong) IBOutlet UISegmentedControl *referenceTypeSegmentedControl;
@property (nonatomic, strong) IBOutlet UIImageView *imgUserPhoto;
@property (nonatomic, strong) IBOutlet UILabel *lblUserName;
@property (nonatomic, strong) ReferenceClient *referenceClient;
@property (nonatomic, strong) Reference *reference;
@end

@implementation CreateReferenceViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.txtReference.text = @"";
    
    self.lblUserName.text = self.user.name;
    [self.imgUserPhoto setUserPhotoStyle];
    [self.imgUserPhoto setImageWithURL:[NSURL URLWithString:self.user.photoUrl]
                      placeholderImage:[UIImage imageNamed:USER_PHOTO_PLACEHOLDER]];
    
    self.txtReference.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txtReference.layer.borderWidth = .6;
    
    [self fetchExistingComment];
}

#pragma mark - Private Methods -

- (void)fetchExistingComment
{
    [self showLoader];
    
    [self.referenceClient fetchReferenceFromUser:[User currentUser]
                                          toUser:self.user
                                  withCompletion:^(Reference *reference, NSError *error) {
                                      
                                      self.txtReference.text = reference.text;
                                      self.referenceTypeSegmentedControl.selectedSegmentIndex = ([reference.type isEqual:ReferenceTypeNegative]) ? 1 : 0;
                                      [self.txtReference becomeFirstResponder];
                                      [self hideLoader];
                                      
                                      if (error)
                                      {
                                          [self alertWithtitle:@"Error"
                                                    andMessage:@"There was a problem getting reference information"];
                                      }
                                      else
                                      {
                                          self.reference = (reference) ? reference : [[Reference alloc] init];
                                      }
                                  }];
}

#pragma mark - IBActions -

- (IBAction)sendSelected:(id)sender
{
    if (!self.reference)
    {
        [self alertWithtitle:@"Error" andMessage:@"Could not submit your reference please try again later"];
        return;
    }
    
    if (!self.txtReference.text.length)
    {
        [self alertWithtitle:@"Error" andMessage:@"Reference text is required"];
        return;
    }
    
    if (self.referenceTypeSegmentedControl.selectedSegmentIndex == -1)
    {
        [self alertWithtitle:@"Error" andMessage:@"Reference type is required"];
        return;
    }
    
    self.reference.from = [User currentUser];
    self.reference.to = self.user;
    self.reference.text = self.txtReference.text;
    self.reference.type = (self.referenceTypeSegmentedControl.selectedSegmentIndex == 1) ? ReferenceTypeNegative : ReferenceTypePositive;
    
    [self.referenceClient saveReference:self.reference withCompletion:^(NSError *error) {
        if (error)
        {
            [self alertWithtitle:@"Error" andMessage:@"Could not submit your reference please try again later"];
        }
        else
        {
            [self.delegate createReferenceViewControllerDidSubmitReference:self.reference];
        }
    }];
}

- (IBAction)cancelSelected
{
    [self.delegate createReferenceViewControllerDidCancel];
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
