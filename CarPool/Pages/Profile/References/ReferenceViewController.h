//
//  ReferenceViewController.h
//  CarPool
//
//  Created by Aryan on 5/26/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"
#import "ReferenceClient.h"

@interface ReferenceViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *referenceType;
@property (nonatomic, strong) NSMutableArray *references;
@property (nonatomic, strong) ReferenceClient *referencesClient;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableSet *expandedRefernceIds;
@property (nonatomic, assign) BOOL moreDataToLaod;

@end
