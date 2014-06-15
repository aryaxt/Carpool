//
//  NoContentView.m
//  CarPool
//
//  Created by Aryan on 6/14/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "NoContentView.h"
#import "UIColor+Additions.h"

@interface NoContentView()
@property (nonatomic, strong) IBOutlet UILabel *lblMessage;
@property (nonatomic, strong) IBOutlet UIView *innerView;
@end

@implementation NoContentView

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    self.innerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.innerView.layer.borderWidth = 1;
    self.innerView.backgroundColor = [UIColor lightBackgroundColor];
    self.innerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.innerView.layer.shadowRadius = 2;
    self.innerView.layer.shadowOpacity = .8;
    self.innerView.layer.shadowOffset = CGSizeMake(1, 1);
    self.lblMessage.textColor = [UIColor darkGrayColor];
    
    return self;
}

@end
