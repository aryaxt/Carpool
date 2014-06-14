//
//  ProfileEditableHeader.h
//  CarPool
//
//  Created by Aryan on 6/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileEditableHeader;
@protocol ProfileEditableHeaderDelegate <NSObject>
- (void)profileEditableHeaderDidSelectEdit:(ProfileEditableHeader *)header;
- (void)profileEditableHeaderDidSelectSave:(ProfileEditableHeader *)header;
- (void)profileEditableHeaderDidSelectCancel:(ProfileEditableHeader *)header;
@end

typedef enum {
    ProfileEditableHeaderModeNormal,
    ProfileEditableHeaderModeEditing,
    ProfileEditableHeaderModeSaving
}ProfileEditableHeaderMode;

@interface ProfileEditableHeader : UIView

@property (nonatomic, weak) id<ProfileEditableHeaderDelegate> delegate;
@property (nonatomic, assign) ProfileEditableHeaderMode mode;

- (id)initWithTitle:(NSString *)title editingEnabled:(BOOL)enabled;

@end
