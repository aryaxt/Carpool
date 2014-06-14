//
//  ProfileEditableCell.h
//  CarPool
//
//  Created by Aryan on 6/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileEditableCell;
@protocol ProfileEditableCellDelegate <NSObject>
- (void)profileEditableCellDidChangeSize:(ProfileEditableCell *)cell;
@end

@interface ProfileEditableCell : UITableViewCell

@property (nonatomic, weak) id <ProfileEditableCellDelegate> delegate;

- (void)setIsInEditMode:(BOOL)editMode;
- (void)setText:(NSString *)text;
- (NSString *)editedText;

@end
