//
//  ReferencesViewController.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "ReferenceClient.h"
#import "User.h"

@interface ReferencesViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *positiveReferences;
@property (nonatomic, strong) NSMutableArray *negativeReferences;
@property (nonatomic, strong) ReferenceClient *referencesClient;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) BOOL morePositiveToLoad;
@property (nonatomic, assign) BOOL moreNegativeToLoad;

- (IBAction)segmentedControlDidChange:(id)sender;

@end
