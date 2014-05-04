//
//  CurrentLocationHeaderView.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurrentLocationHeaderViewDelegate <NSObject>
- (void)currentLocationHeaderViewDidDetectTap;
@end

@interface CurrentLocationHeaderView : UIView

@property (nonatomic, weak) id <CurrentLocationHeaderViewDelegate> delegate;

- (IBAction)currentLocationSelected:(id)sender;

@end
