//
//  ReferenceClient.h
//  CarPool
//
//  Created by Aryan on 5/24/14.
//  Copyright (c) 2014 aryaxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Reference.h"

@interface ReferenceClient : NSObject

- (void)saveReference:(Reference *)reference withCompletion:(void (^)(NSError *error))completion;
- (void)fetchReferenceFromUser:(User *)from toUser:(User *)to withCompletion:(void (^)(Reference *, NSError *error))completion;
- (void)fetchReferenceCountsForUser:(User *)user withCompletion:(void (^) (NSNumber *poitive, NSNumber *negative, NSError *error))completion;
- (void)fetchReferencesForUser:(User *)user byType:(NSString *)type andCompletion:(void (^)(NSArray *references, NSError *error))completion;

@end
