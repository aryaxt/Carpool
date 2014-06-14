//
//  ProfileEditableHeader.m
//  CarPool
//
//  Created by Aryan on 6/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ProfileEditableHeader.h"

@interface ProfileEditableHeader()
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit;
@property (nonatomic, strong) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loader;
@end

@implementation ProfileEditableHeader

#pragma mark - Initialization -

- (id)initWithTitle:(NSString *)title editingEnabled:(BOOL)enabled
{
    if (self = [self init])
    {
        self.lblTitle.text = title;
        
        if (enabled)
        {
            
        }
        else
        {
            [self disableEditing];
        }
    }
    
    return self;
}

- (id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    self.mode = ProfileEditableHeaderModeNormal;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = .6;
    return self;
}

#pragma mark - Private Methods -

- (void)disableEditing
{
    self.btnCancel.hidden = YES;
    self.btnSave.hidden = YES;
    self.btnEdit.hidden = YES;
}

#pragma mark - IBActions -

- (IBAction)saveSelected:(id)sender
{
    [self.delegate profileEditableHeaderDidSelectSave:self];
}

- (IBAction)cancelSelected:(id)sender
{
    [self.delegate profileEditableHeaderDidSelectCancel:self];
}

- (IBAction)editSelected:(id)sender
{
    [self.delegate profileEditableHeaderDidSelectEdit:self];
}

#pragma mark - Setter & Getter -

- (void)setMode:(ProfileEditableHeaderMode)mode
{
    _mode = mode;
    
    self.btnCancel.hidden = (mode == ProfileEditableHeaderModeEditing) ? NO : YES;
    self.btnSave.hidden = (mode == ProfileEditableHeaderModeEditing) ? NO : YES;
    self.btnEdit.hidden = (mode == ProfileEditableHeaderModeNormal) ? NO : YES;
    
    if (mode == ProfileEditableHeaderModeSaving)
        [self.loader startAnimating];
    else
        [self.loader stopAnimating];
}

@end
