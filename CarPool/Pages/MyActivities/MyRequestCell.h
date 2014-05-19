//
//  MyRequestCell.h
//  CarPool
//
//  Created by Aryan on 5/18/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarPoolRequest.h"

@interface MyRequestCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgFromPhoto;
@property (nonatomic, strong) IBOutlet UILabel *lblFromName;
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UILabel *lblFrom;
@property (nonatomic, strong) IBOutlet UILabel *lblTo;

- (void)setRequest:(CarPoolRequest *)request;

@end
