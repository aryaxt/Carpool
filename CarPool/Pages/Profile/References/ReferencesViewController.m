//
//  ReferencesViewController.m
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ReferencesViewController.h"
#import "ReferenceCell.h"
#import "UITableView+Additions.h"

@implementation ReferencesViewController

#define RESULT_PER_PAGE 25

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.positiveReferences = [NSMutableArray array];
    self.negativeReferences = [NSMutableArray array];
    
    self.morePositiveToLoad = YES;
    self.moreNegativeToLoad = YES;

    [self fetchAndPopulateReferenceByType:ReferenceTypePositive];
    [self fetchAndPopulateReferenceByType:ReferenceTypeNegative];
}

- (void)fetchAndPopulateReferenceByType:(NSString *)type
{
    NSInteger skip = ([type isEqualToString:ReferenceTypePositive])
        ? self.positiveReferences.count
        : self.negativeReferences.count;
    
    BOOL moreToLoad = ([type isEqualToString:ReferenceTypePositive])
        ? self.morePositiveToLoad
        : self.moreNegativeToLoad;
    
    if (!moreToLoad)
        return;
    
    [self.referencesClient fetchReferencesForUser:self.user
                                           byType:type
                                             limit:RESULT_PER_PAGE
                                          skip:skip
                                    andCompletion:^(NSArray *references, NSError *error) {
                                        if (error)
                                        {
                                            [self alertWithtitle:@"Error" andMessage:@"Problem reading references"];
                                        }
                                        else
                                        {
                                            [self insertNewReferences:references withType:type];
                                        }
                                    }];
}

#pragma mark - Private Methods -

- (void)insertNewReferences:(NSArray *)newReferences withType:(NSString *)type
{
    BOOL shouldAnimate = NO;
    NSMutableArray *references;
    
    if (type == ReferenceTypePositive)
    {
        references = self.positiveReferences;
        self.morePositiveToLoad = (references.count == RESULT_PER_PAGE) ? YES : NO;
        
        if (self.segmentedControl.selectedSegmentIndex == 0)
            shouldAnimate = YES;
    }
    else if (type == ReferenceTypeNegative)
    {
        references = self.negativeReferences;
        self.moreNegativeToLoad = (references.count == RESULT_PER_PAGE) ? YES : NO;
        
        if (self.segmentedControl.selectedSegmentIndex == 1)
            shouldAnimate = YES;
    }
    
    int oldCount = (int)references.count;
    [references addObjectsFromArray:newReferences];
    
    if (shouldAnimate)
    {
        [self.tableView beginUpdates];
        for (int i=oldCount ; i<references.count ; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
        [self.tableView endUpdates];
    }
}

#pragma mark - IBActions -

- (IBAction)segmentedControlDidChange:(id)sender
{
    NSInteger count = (self.segmentedControl.selectedSegmentIndex == 0)
        ? self.positiveReferences.count
        : self.negativeReferences.count;
    
    int insertAnimation = (self.segmentedControl.selectedSegmentIndex == 0) ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight;
    int deleteAnimation = (self.segmentedControl.selectedSegmentIndex == 0) ? UITableViewRowAnimationRight : UITableViewRowAnimationLeft;
    
    
    [self.tableView deleteRowsAndAnimateNewRows:count inSection:0 withDeleteAnimatiion:deleteAnimation andInsertAnimation:insertAnimation];
}

#pragma mark - UITableView Delegate & Datasource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.segmentedControl.selectedSegmentIndex == 0)
        ? self.positiveReferences.count
        : self.negativeReferences.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ReferenceCell";
    ReferenceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Reference *reference = (self.segmentedControl.selectedSegmentIndex == 0)
        ? [self.positiveReferences objectAtIndex:indexPath.row]
        : [self.negativeReferences objectAtIndex:indexPath.row];

    [cell setReference:reference];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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