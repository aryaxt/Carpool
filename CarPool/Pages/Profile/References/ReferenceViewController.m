//
//  ReferenceViewController.m
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ReferenceViewController.h"
#import "ReferenceCell.h"
#import "UITableView+Additions.h"
#import <SVPullToRefresh/UIScrollView+SVInfiniteScrolling.h>
#import "ReferenceClient.h"

#define RESULT_PER_PAGE 10
#define CELL_IDENTIFIER @"ReferenceCell"

@interface ReferenceViewController()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *references;
@property (nonatomic, strong) ReferenceClient *referencesClient;
@property (nonatomic, strong) NSMutableSet *expandedRefernceIds;
@property (nonatomic, assign) BOOL moreDataToLaod;
@end

@implementation ReferenceViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.expandedRefernceIds = [NSMutableSet set];
    self.references = [NSMutableArray array];
    self.moreDataToLaod = YES;

    __weak ReferenceViewController *weakReference = self;
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (weakReference.moreDataToLaod)
            [weakReference fetchAndPopulateReferences];
    }];
    
    [self showLoader];
    [self fetchAndPopulateReferences];
}

#pragma mark - Private Methods -

- (void)fetchAndPopulateReferences
{
    NSInteger skip = self.references.count;
    
    [self.referencesClient fetchReferencesForUser:self.user
                                           byType:self.referenceType
                                            limit:RESULT_PER_PAGE
                                             skip:skip
                                    andCompletion:^(NSArray *newReferences, NSError *error) {
                                        
                                        [self.tableView.infiniteScrollingView stopAnimating];
                                        [self hideLoader];
                                        
                                        if (error)
                                        {
                                            [self alertWithtitle:@"Error" andMessage:@"Problem reading references"];
                                        }
                                        else
                                        {
                                            self.moreDataToLaod = (newReferences.count < RESULT_PER_PAGE) ? NO : YES;
                                            self.tableView.showsInfiniteScrolling = self.moreDataToLaod;
                                            
                                            int oldCount = (int)self.references.count;
                                            
                                            [self.tableView beginUpdates];
                                            [self.references addObjectsFromArray:newReferences];
                                            for (int i=oldCount ; i<self.references.count ; i++)
                                            {
                                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                            }
                                            [self.tableView endUpdates];
                                            
                                            if (oldCount > 0)
                                            {
                                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:oldCount inSection:0];
                                                
                                                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                                            }
                                            
                                            [self showNoContent:self.references.count ? NO : YES];
                                        }
                                    }];
}

- (BOOL)isReferenceExpanded:(Reference *)reference
{
    return [self.expandedRefernceIds containsObject:reference.objectId];
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.references.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReferenceCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    Reference *reference = [self.references objectAtIndex:indexPath.row];
    
    [cell setReference:reference isExpanded:[self isReferenceExpanded:reference]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Reference *reference = [self.references objectAtIndex:indexPath.row];
    ReferenceCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    CGRect expectedRect = [cell setReference:reference isExpanded:[self isReferenceExpanded:reference]];
    
    return expectedRect.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Reference *reference = [self.references objectAtIndex:indexPath.row];
    
    if ([self.expandedRefernceIds containsObject:reference.objectId])
    {
        [self.expandedRefernceIds removeObject:reference.objectId];
    }
    else
    {
        [self.expandedRefernceIds addObject:reference.objectId];
    }
    
    ReferenceCell *cell = (ReferenceCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setReference:reference isExpanded:[self isReferenceExpanded:reference]];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - Setter & Getter -

- (ReferenceClient *)referencesClient
{
    if (!_referencesClient)
    {
        _referencesClient = [[ReferenceClient alloc] init];
    }
    
    return _referencesClient;
}

@end
