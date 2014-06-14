//
//  ReferenceCell.m
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ReferenceCell.h"
#import "UIImageView+Additions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#define COLLAPSED_NUMBER_OF_LINES 3
#define REFEREENCE_TEXT_OFFSET 10

@interface ReferenceCell()
@property (nonatomic, strong) IBOutlet UIImageView *imgFromPhoto;
@property (nonatomic, strong) IBOutlet UILabel *lblFromName;
@property (nonatomic, strong) IBOutlet UILabel *lblCreatedDate;
@property (nonatomic, strong) IBOutlet UILabel *lblUpdatedDate;
@property (nonatomic, strong) IBOutlet UILabel *lblUpdatedDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *lblText;
@end

@implementation ReferenceCell

- (CGRect)setReference:(Reference *)reference isExpanded:(BOOL)expanded
{
    [self.imgFromPhoto setUserPhotoStyle];
    [self.imgFromPhoto setImageWithURL:[NSURL URLWithString:reference.from.photoUrl]
                           placeholderImage:[UIImage imageNamed:USER_PHOTO_PLACEHOLDER]];
    
    self.lblFromName.text = reference.from.name;
    self.lblText.text = reference.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    self.lblCreatedDate.text = [dateFormatter stringFromDate:reference.createdAt];
    self.lblUpdatedDate.text = [dateFormatter stringFromDate:reference.updatedAt];
    self.lblUpdatedDate.hidden = ([reference.createdAt isEqualToDate:reference.updatedAt]) ? YES : NO;
    self.lblUpdatedDateLabel.hidden = ([reference.createdAt isEqualToDate:reference.updatedAt]) ? YES : NO;
    
    CGRect textRect = self.lblText.frame;
    textRect.origin.x = REFEREENCE_TEXT_OFFSET;
    textRect.size.width = self.frame.size.width - (REFEREENCE_TEXT_OFFSET*2);
    self.lblText.frame = textRect;
    
    self.lblText.numberOfLines = (expanded) ? 0 : COLLAPSED_NUMBER_OF_LINES;
    self.lblText.text = reference.text;
    [self.lblText sizeToFit];
    
    CGRect rect = self.frame;
    rect.size.height = self.lblText.frame.origin.y + self.lblText.frame.size.height + 5;
    return rect;
}

@end
