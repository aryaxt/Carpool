//
//  ApplicationVersionManager.m
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import "ApplicationVersionManager.h"
#import "ApplicationVersionClient.h"

@interface ApplicationVersionManager()
@property (nonatomic, strong) ApplicationVersionClient *client;
@end

@implementation ApplicationVersionManager

#define PLATFORM @"ios"

#pragma mark - Initialization -

+ (ApplicationVersionManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static ApplicationVersionManager *singleTon;
    
    dispatch_once(&onceToken, ^{
        singleTon = [[ApplicationVersionManager alloc] init];
    });
    
    return singleTon;
}

- (id)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [self checkForValidVersion];
    }
    
    return self;
}

#pragma mark - Private MEthods -

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [self checkForValidVersion];
}

- (void)checkForValidVersion
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    float currentVersion = [version floatValue];
    
    [self.client fetchLatestByPlatform:PLATFORM
                         andCompletion:^(ApplicationVersion *applicationVersion, NSError *error) {
                             if (!applicationVersion)
                                return;
                             
                             BOOL forceUpdate = currentVersion < applicationVersion.lastRequiredVersion.floatValue ? YES : NO;
                             BOOL update = currentVersion < applicationVersion.version.floatValue ? YES : NO;
                             
                             if (!error && update)
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     UIAlertView *alertView = [[UIAlertView alloc] init];
                                     alertView.title = @"Application Update";
                                     alertView.message = (forceUpdate)
                                        ? @"This version has expired please update to the latest version."
                                        : [NSString stringWithFormat:@"A newer version is available to download.\n%@", applicationVersion.message];
                                     
                                     if (!forceUpdate)
                                     {
                                         [alertView addButtonWithTitle:@"Ok"];
                                     }
                                     
                                     [alertView show];
                                 });
                             }
                         }];
}

#pragma mark - Setter & Getter -

- (ApplicationVersionClient *)client
{
    if (!_client)
    {
        _client = [[ApplicationVersionClient alloc] init];
    }
    
    return _client;
}

@end
