//
//  CalendarViewController.m
//  CarPool
//
//  Created by Aryan on 6/19/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "CalendarViewController.h"
#import "NSDate+Additions.h"
#import "CalendarCell.h"
#import "RequestOrOfferCell.h"
#import "CalendarHeader.h"
#import "CarPoolOfferClient.h"
#import "CarPoolRequestClient.h"
#import "NSArray+Additions.h"

@interface CalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CalendarHeaderDelegate>
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UILabel *lblMonth;
@property (nonatomic, strong) NSDate *currentCalendarDate;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSMutableArray *datesInMonth;
@property (nonatomic, strong) CarPoolOfferClient *offerClient;
@property (nonatomic, strong) CarPoolRequestClient *requestClient;
@property (nonatomic, strong) NSArray *requests;
@property (nonatomic, strong) NSArray *offers;
@property (nonatomic, strong) NSMutableArray *requestsAndOffersForSelectedDate;
@end

@implementation CalendarViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datesInMonth = [NSMutableArray array];
    self.requestsAndOffersForSelectedDate = [NSMutableArray array];
    self.currentCalendarDate = [NSDate date];
    self.selectedDate = [NSDate date];
    
    [self showLoader];
    [self populateCurrentMonthCalendar];
    [self fetchAndPopulateRequestsAndOffers];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - UICollectionView -

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
        return self.datesInMonth.count;
    else
        return self.requestsAndOffersForSelectedDate.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CalendarCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
        
        NSDate *date = [self.datesInMonth objectAtIndex:indexPath.row];
        BOOL isCurrentMonth = (date.month == self.currentCalendarDate.month);
        BOOL isSelected = [self.selectedDate isTheSameDayAs:date];
        
        NSArray *offers = [self.offers where:^BOOL(CarPoolOffer *offer) {
            return [offer.date isTheSameDayAs:date];
        }];
        
        NSArray *requests = [self.requests where:^BOOL(CarPoolRequest *request) {
            return [request.date isTheSameDayAs:date];
        }];
        
        #warning do we want to pass offers and reuquests to cell?
        [cell setDate:date isInCurrentMonth:isCurrentMonth isSelected:isSelected withOffers:offers andRequests:requests];
        
        return cell;
    }
    else
    {
        RequestOrOfferCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"RequestOrOfferCell" forIndexPath:indexPath];
        
        id offerOrRequest = [self.requestsAndOffersForSelectedDate objectAtIndex:indexPath.row];
        
        if ([offerOrRequest isKindOfClass:[CarPoolOffer class]])
        {
            [cell setOffer:offerOrRequest];
        }
        if ([offerOrRequest isKindOfClass:[CarPoolRequest class]])
        {
            [cell setRequest:offerOrRequest];
        }
        
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CalendarHeader *header =  [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalendarHeader" forIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        [header setDate:self.currentCalendarDate];
        [header setDelegate:self];
    }
    else
    {
        header.frame = CGRectZero;
    }
    
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CGFloat size = self.view.frame.size.width/7.0;
        return CGSizeMake(size, 70);
    }
    else
    {
        return CGSizeMake(self.view.frame.size.width, 70);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.collectionView.frame.size.width, (section == 0) ? 64 : 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedDate = [self.datesInMonth objectAtIndex:indexPath.row];
    [self.collectionView reloadData];
    
    [self populateOffersAndRequestsInSelectedDay];
}

#pragma mark - Private MEthods -

- (void)fetchAndPopulateRequestsAndOffers
{
    __block NSInteger completionCount = 0;
    
    void(^completion)(void) = ^(void) {
        completionCount++;
        
        if(completionCount == 2)
        {
            [self hideLoader];
            [self.collectionView reloadData];
            [self populateOffersAndRequestsInSelectedDay];
        }
    };
    
    [self.offerClient fetchMyOffersIncludeLocations:NO includeUser:NO withCompletion:^(NSArray *offers, NSError *error) {
        self.offers = offers;
        completion();
    }];
    
    [self.requestClient fetchMyRequestsIncludeOffer:NO includeFrom:NO includeTo:NO withCompletion:^(NSArray *requests, NSError *error) {
        self.requests = requests;
        completion();
    }];
}

- (void)populateCurrentMonthCalendar
{
    [self.collectionView performBatchUpdates:^{
        for (int i=0 ; i<[self collectionView:self.collectionView numberOfItemsInSection:0] ; i++)
        {
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
        }
        
        [self.datesInMonth removeAllObjects];
    } completion:^(BOOL finished) {
        NSDate *firstDayOfMonth = [self.currentCalendarDate firstDayInMonth];
        
        for (int i = 1 ; i< firstDayOfMonth.weekDay ; i++)
        {
            NSDate *lastMonthDay = [firstDayOfMonth dateByAddingDays:-1*i];
            [self.datesInMonth insertObject:lastMonthDay atIndex:0];
        }
        
        for (int i=0 ; i<[firstDayOfMonth numberOfDaysInMonth] ; i++)
        {
            NSDate *date  = [firstDayOfMonth dateByAddingDays:i];
            [self.datesInMonth addObject:date];
        }
        
        [self.collectionView performBatchUpdates:^{
            for (int i=0 ; i<self.datesInMonth.count ; i++)
            {
                [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
            }
        } completion:nil];
    }];
}

- (void)populateOffersAndRequestsInSelectedDay
{
    [self.collectionView performBatchUpdates:^{
        for (int i=0 ; i<self.requestsAndOffersForSelectedDate.count ; i++)
        {
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]]];
        }
        
        [self.requestsAndOffersForSelectedDate removeAllObjects];
    } completion:^(BOOL finished) {

        [self.requestsAndOffersForSelectedDate addObjectsFromArray:[self.offers where:^BOOL(CarPoolOffer *offer) {
            return [offer.date isTheSameDayAs:self.selectedDate];
        }]];
        
        [self.requestsAndOffersForSelectedDate addObjectsFromArray:[self.requests where:^BOOL(CarPoolRequest *request) {
            return [request.date isTheSameDayAs:self.selectedDate];
        }]];
        
        [self.collectionView performBatchUpdates:^{
            for (int i=0 ; i<self.requestsAndOffersForSelectedDate.count ; i++)
            {
                [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]]];
            }
        } completion:nil];
    }];
}

#pragma mark - CalendarHeaderDelegate -

- (void)calendarHeaderDidSelectNextMonth
{
    self.currentCalendarDate = [self.currentCalendarDate firstDayOfNextMonth];
    [self populateCurrentMonthCalendar];
}

- (void)calendarHeaderDidSelectPreviousMonth
{
    self.currentCalendarDate = [self.currentCalendarDate firstDayOfLastMonth];
    [self populateCurrentMonthCalendar];
}

#pragma mark - Setter & Getter -

- (CarPoolRequestClient *)requestClient
{
    if (!_requestClient)
    {
        _requestClient = [[CarPoolRequestClient alloc] init];
    }
    
    return _requestClient;
}

- (CarPoolOfferClient *)offerClient
{
    if (!_offerClient)
    {
        _offerClient = [[CarPoolOfferClient alloc] init];
    }
    
    return _offerClient;
}

@end
