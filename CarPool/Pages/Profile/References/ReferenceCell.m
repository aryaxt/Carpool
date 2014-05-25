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

@implementation ReferenceCell

- (void)setReference:(Reference *)reference
{
    [self.imgFromPhoto setUserPhotoStyle];
    [self.imgFromPhoto setImageWithURL:[NSURL URLWithString:reference.from.photoUrl]
                           placeholderImage:[UIImage imageNamed:@"adfsdf"]];
    
    self.lblFromName.text = reference.from.name;
    self.lblText.text = reference.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    self.lblCreatedDate.text = [dateFormatter stringFromDate:reference.createdAt];
    self.lblUpdatedDate.text = [dateFormatter stringFromDate:reference.updatedAt];
    self.lblUpdatedDate.hidden = ([reference.createdAt isEqualToDate:reference.updatedAt]) ? YES : NO;
}

@end