//
//  CurrentLocationHeaderView.h
//  CarPool
//
//  Created by Aryan on 5/4/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationSearchHeaderViewDelegate <NSObject>
- (void)locationSearchHeaderViewDidSelectCurrentLocationSearch;
- (void)locationSearchHeaderViewDidSelectMapSearch;
@end

@interface LocationSearchHeaderView : UIView

@property (nonatomic, weak) id <LocationSearchHeaderViewDelegate> delegate;

- (IBAction)currentLocationSelected:(id)sender;
- (IBAction)mapSelected:(id)sender;

@end
