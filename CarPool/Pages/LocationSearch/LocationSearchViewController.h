//
//  LocationSearchViewController.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Location.h"

@protocol LocationSearchViewControllerDelegate <NSObject>
- (void)locationSearchViewControllerDidSelectCancel;
- (void)locationSearchViewControllerDidSelectLocation:(Location *)location withTag:(NSString *)tag;
@end

@interface LocationSearchViewController : BaseViewController

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, weak) id <LocationSearchViewControllerDelegate> delegate;

@end
