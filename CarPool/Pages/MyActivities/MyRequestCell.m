//
//  MyRequestCell.m
//  CarPool
//
//  Created by Aryan on 5/18/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "MyRequestCell.h"
#import "UIImageView+Additions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MyRequestCell()
@property (nonatomic, strong) IBOutlet UIImageView *imgFromPhoto;
@property (nonatomic, strong) IBOutlet UILabel *lblFromName;
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UILabel *lblFrom;
@property (nonatomic, strong) IBOutlet UILabel *lblTo;
@end

@implementation MyRequestCell

#pragma mark - Public Methods -

- (void)setRequest:(CarPoolRequest *)request
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    self.lblTime.text = [dateFormatter stringFromDate:request.date];
    self.lblFrom.text = request.startLocation.name;
    self.lblTo.text = request.endLocation.name;
    self.lblFromName.text = request.to.name;
    [self.imgFromPhoto setUserPhotoStyle];
    [self.imgFromPhoto setImageWithURL:[NSURL URLWithString:request.to.photoUrl]
                      placeholderImage:[UIImage imageNamed:@"sdfsdf"]];
}

@end
