//
//  ReferenceCell.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reference.h"

@interface ReferenceCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgFromPhoto;
@property (nonatomic, strong) IBOutlet UILabel *lblFromName;
@property (nonatomic, strong) IBOutlet UILabel *lblCreatedDate;
@property (nonatomic, strong) IBOutlet UILabel *lblUpdatedDate;
@property (nonatomic, strong) IBOutlet UILabel *lblText;

- (void)setReference:(Reference *)reference;

@end
