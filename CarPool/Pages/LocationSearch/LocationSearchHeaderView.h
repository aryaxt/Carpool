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
@end

@interface LocationSearchHeaderView : UIView

@property (nonatomic, weak) id <LocationSearchHeaderViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicatorView;

- (IBAction)currentLocationSelected:(id)sender;
- (void)setShowLoader:(BOOL)show;

@end
